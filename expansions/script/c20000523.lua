--灭寂罪魔凰
local cm,m,o=GetID()
function cm.initial_effect(c)
	aux.AddCodeList(c,20000516)
	aux.AddXyzProcedure(c,nil,10,3)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,1))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_F)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.con1)
	e1:SetTarget(cm.tg1)
	e1:SetOperation(cm.op1)
	c:RegisterEffect(e1)
	--cannot target
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetValue(aux.tgoval)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_EXTRA_ATTACK)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_ATTACK_ANNOUNCE)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(cm.con2)
	e4:SetOperation(cm.op2)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e5:SetCode(EVENT_SUMMON_SUCCESS)
	e5:SetRange(LOCATION_GRAVE)
	e5:SetCondition(cm.con5)
	e5:SetOperation(cm.op5)
	c:RegisterEffect(e5)
	local e6=e5:Clone()
	e6:SetCode(EVENT_CHAINING)
	e6:SetCondition(cm.con6)
	c:RegisterEffect(e6)
end
--e1
function cm.conf1(c,e,tp)
	return c:IsControler(tp) and (not e or c:IsRelateToEffect(e))
end
function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOverlayGroup():IsExists(Card.IsCode,1,nil,20000516) and eg:IsExists(cm.conf1,1,nil,nil,1-tp) 
		and not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED)
end
function cm.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetCard(eg)
end
function cm.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local g=eg:Filter(cm.conf1,nil,e,1-tp)
	local dg=Group.CreateGroup()
	local tc=g:GetFirst()
	while tc do
		if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
			local og=tc:GetOverlayGroup()
			if og:GetCount()>0 then
				Duel.SendtoGrave(og,REASON_RULE)
			end
			dg:AddCard(tc)
		end
		tc=g:GetNext()
	end
	Duel.Overlay(c,dg)
end
--e4
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp and Duel.GetAttackTarget()~=e:GetHandler()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		local at=Duel.GetAttacker()
		if at:IsAttackable() and not at:IsImmuneToEffect(e) then
			Duel.CalculateDamage(at,c)
		end
	end
end
--e5
function cm.con5(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(Card.IsRace,1,nil,RACE_FIEND)
end
function cm.opf5(c)
	return c:IsSetCard(0x3fd5,0xfd6)
end
function cm.op5(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.opf5,tp,LOCATION_GRAVE,0,e:GetHandler())
	if Duel.GetLocationCount(tp,LOCATION_MZONE,0)>0 and #g>3 
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.SelectYesNo(tp,aux.Stringid(m,0)) then
		Duel.Hint(HINT_CARD,0,m)
		g = g:Select(tp,4,4,e:GetHandler())
		if Duel.SpecialSummonStep(e:GetHandler(),0,tp,tp,false,false,POS_FACEUP) then
			Duel.Overlay(e:GetHandler(),g)
			Duel.SpecialSummonComplete()
		end
	end
end
--e6
function cm.con6(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_SPELL)
end