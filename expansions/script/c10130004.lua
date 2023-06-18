--量子驱动 ε装载机
if not pcall(function() require("expansions/script/c10130001") end) then require("script/c10130001") end
local s,id = GetID()
function s.initial_effect(c)
	local e1 = Scl_Quantadrive.FilpEffect(c, s, id, "AddFromDeck2Hand", "AddFromDeck2Hand", { "~Target", "AddFromDeck2Hand", s.thfilter, "Deck" }, s.thop)
	local e2 = Scl.CreateQuickOptionalEffect(c, "FreeChain", "ChangePosition", {1, id}, "ChangePosition", nil, "Hand", nil, { "Cost", "Reveal", aux.NOT(Card.IsPublic) }, { "~Target", "ChangePosition", s.cpfilter, "MonsterZone" }, s.cpop)
	Scl_Quantadrive.CreateNerveContact(s, e1, e2)
end
function s.thfilter(c)
	return c:IsSetCard(0xa336) and c:IsType(TYPE_MONSTER) and not c:IsCode(id) and c:IsAbleToHand()
end
function s.thop(e,tp)
	Scl.SelectAndOperateCards("AddFromDeck2Hand",tp,s.thfilter,tp, "Deck",0,1,1,nil)()
end
function s.cpfilter(c)
	return c:IsFacedown() and c:IsCanChangePosition() and c:IsSetCard(0xa336)
end
function s.cpop(e,tp)
	Scl.SelectAndOperateCards("Change2FaceupDefensePosition",tp,s.cpfilter,tp,"MonsterZone",0,1,1,nil)()
end