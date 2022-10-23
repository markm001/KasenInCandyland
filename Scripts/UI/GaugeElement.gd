extends Control

func _ready():
	GlobalData.connect("gauge_updated", self, "_on_update_gauge");

func _on_update_gauge(rai_gauge:int, kou_gauge:int):
	$RaiGauge.value = rai_gauge;
	$KouGauge.value = kou_gauge;
