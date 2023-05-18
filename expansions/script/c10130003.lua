--量子驱动 δ指令机
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl_Quantadrive.FilpEffect(c, s, id, "PlaceOnField", "PlaceOnField", { "~Target", "PlaceOnField", s.afilter, "Deck" }, s.aop)
	local e2 = Scl.CreateQuickOptionalEffect(c, "FreeChain", "ChangePosition", {1, id}, "ChangePosition", nil, "Hand", nil, { "Cost", "Reveal", aux.NOT(Card.IsPublic) }, { "~Target", "ChangePosition", s.cpfilter, "MonsterZone" }, s.cpop)
	Scl_Quantadrive.CreateNerveContact(s, e1, e2)
end
function s.afilter(c,e,tp)
	--if you want to activate rather than place, then add the below filter, due to those spells/traps cannot activate during damage step, the filter will return false (like be filpped faceup because of a battle)
	--c:GetActivateEffect():IsActivatable(tp, true, true)
	return Scl.IsType(c, 0, TYPE_SPELL + TYPE_CONTINUOUS, TYPE_TRAP + TYPE_CONTINUOUS, TYPE_SPELL + TYPE_FIELD) and (c:IsType(TYPE_FIELD) or Duel.GetLocationCount(tp,LOCATION_SZONE) > 0) and not c:IsForbidden() and c:IsSetCard(0xa336)
end
function s.aop(e,tp)
	Scl.SelectAndOperateCards("PlaceOnField",tp,s.afilter,tp, "Deck",0,1,1,nil,e,tp)()
end
function s.cpfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition() and c:IsSetCard(0xa336)
end
function s.cpop(e,tp)
	Scl.SelectAndOperateCards("Change2FaceupDefensePosition",tp,s.cpfilter,tp,"MonsterZone",0,1,1,nil)()
end