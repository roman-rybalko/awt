<?php

namespace AdvancedWebTesting\Task\Type;

/**
 * Управление типами задач
 * Model (MVC)
 */
class Manager {
	private $table;

	public function __construct(\WebConstructionSet\Database\Relational $db) {
		$this->table = new \WebConstructionSet\Database\Relational\TableWrapper($db, 'task_types');
	}

	/**
	 * @param [integer]|null $typeIds null - все
	 * @return [][name => string, id => integer, parent_id => integer]
	 */
	public function get($typeIds = null) {
		$data = [];
		if ($typeIds === null)
			$data = $this->table->select(['name', 'type_id', 'parent_type_id']);
		else
			foreach ($typeIds as $typeId)
				if ($data1 = $this->table->select(['name', 'type_id', 'parent_type_id'], ['type_id' => $typeId]))
					$data = array_merge($data, $data1);
		$types = [];
		foreach ($data as $data1) {
			$type = [];
			foreach (['name' => 'name', 'type_id' => 'id', 'parent_type_id' => 'parent_id'] as $src => $dst)
				$type[$dst] = $data1[$src];
			$types[] = $type;
		}
		return $types;
	}

	/**
	 * Получить у которых отсутствует parent_type_id
	 * @return [integer] typeIds
	 */
	public function getTop() {
		$typeIds = [];
		if ($data = $this->table->select(['type_id'], ['parent_type_id' => null]))
			foreach ($data as $data1)
				$typeIds[] = $data1['type_id'];
		return $typeIds;
	}

	/**
	 * Получить набор для выполнения задачи
	 * @param string $typeName
	 * @return [integer]
	 */
	public function getCompatible($type) {
		$typeIds = [];
		$typeId = null;
		if ($data = $this->table->select(['type_id', 'parent_type_id'], ['name' => $type])) {
			$typeIds[] = $data[0]['type_id'];
			$typeId = $data[0]['parent_type_id'];
		}
		while ($typeId) {
			if ($data = $this->table->select(['parent_type_id'], ['type_id' => $typeId])) {
				$typeIds[] = $typeId;
				$typeId = $data[0]['parent_type_id'];
			} else
				$typeId = null;
		}
		return $typeIds;
	}
}