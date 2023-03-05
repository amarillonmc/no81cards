--渊异术士 幻阵龙
local cm,m,o=GetID()
fu_Abyss = fu_Abyss or {}
function fu_Abyss.Hand_Be_Open(c,code,tg,op,cat)
	local e=Effect.CreateEffect(c)
	e:SetCategory(cat or CATEGORY_TOGRAVE)
	e:SetType(EFFECT_TYPE_IGNITION)
	e:SetRange(LOCATION_HAND)
	e:SetCountLimit(1,code)
	e:SetCost(fu_Abyss.HBO_cos(code))
	e:SetTarget(tg)
	e:SetOperation(op)
	c:RegisterEffect(e)
	return e
end
function fu_Abyss.Hand_Open(c,op)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_PHASE+PHASE_BATTLE_START)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1)
	e1:SetCondition(fu_Abyss.HO_con)
	e1:SetOperation(op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_HAND)
	e2:SetCode(EFFECT_UPDATE_LEVEL)
	e2:SetCondition(fu_Abyss.HO_con)
	e2:SetTargetRange(LOCATION_GRAVE,0)
	e2:SetTarget(fu_Abyss.HO_tg2)
	e2:SetValue(-3)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetTargetRange(1,0)
	e3:SetTarget(fu_Abyss.HO_tg3)
	c:RegisterEffect(e3)
	return e1,e2,e3
end
function fu_Abyss.HBO_cos(code)
	return function(e,tp,eg,ep,ev,re,r,rp,chk)
		if chk==0 then return not e:GetHandler():IsPublic() end
		Duel.ConfirmCards(1-tp,e:GetHandler())
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetDescription(66)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(EFFECT_PUBLIC)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END+RESET_OPPO_TURN)
		e:GetHandler():RegisterEffect(e1)
		Duel.Hint(24,0,aux.Stringid(code,0))
	end
end
function fu_Abyss.HO_con(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsPublic()
end
function fu_Abyss.HO_tg2(e,c)
	return c:GetType()&0x81==0x81
end
function fu_Abyss.HO_tg3(e,c,sump,sumtype,sumpos,targetp,se)
	return not c:IsLocation(LOCATION_GRAVE)
end
if not cm then return end
-----------------------------------------------------------------------------------
function cm.initial_effect(c)
	cm.Hand_Be_Open = fu_Abyss.Hand_Be_Open(c,m,cm.tg1,cm.op1)
	local e1 = {fu_Abyss.Hand_Open(c,cm.op2)}
end
--e1
function cm.tgf1(c)
	return c:IsAbleToGrave() and c:GetType()&0x81==0x81 and c:IsRace(RACE_DRAGON)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgf1,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,cm.tgf1,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	Duel.SendtoGrave(g,REASON_EFFECT)
end
--e2
function cm.opf2(c,e)
	return c:GetType()&0x81==0x81 and (not e or (not c:IsImmuneToEffect(e) and c:IsFaceup()))
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_CARD,0,m)
	local g=Duel.GetMatchingGroup(cm.opf2,tp,LOCATION_MZONE,0,nil,e):Filter(Card.IsRace,nil,RACE_DRAGON)
	local v=Duel.GetMatchingGroup(cm.opf2,tp,LOCATION_MZONE+LOCATION_GRAVE,0,nil):GetMaxGroup(Card.GetBaseAttack)
	if #g==0 or not v then return end
	v=v:GetFirst():GetBaseAttack()
	for tc in aux.Next(g) do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE)
		e1:SetValue(v)
		tc:RegisterEffect(e1)
	end
end