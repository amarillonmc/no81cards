--幻异梦境-水母水族馆
if not c71401001 then dofile("expansions/script/c71400001.lua") end
function c71400058.initial_effect(c)
	--Activate
	--See AddYumeFieldGlobal
	--xyz summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetDescription(aux.Stringid(71400058,0))
	e1:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e1:SetCondition(c71400058.con1)
	e1:SetTarget(c71400058.tg1)
	e1:SetOperation(c71400058.op1)
	e1:SetCost(c71400058.cost1)
	c:RegisterEffect(e1)
	local e1a=e1:Clone()
	e1a:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e1a)
	local e1b=e1:Clone()
	e1b:SetCode(EVENT_CHAINING)
	e1b:SetCondition(c71400058.con1b)
	c:RegisterEffect(e1b)
	--material
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(71400058,1))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCountLimit(1)
	--e2:SetCondition(c71400058.con2)
	e2:SetTarget(c71400058.tg2)
	e2:SetOperation(c71400058.op2)
	c:RegisterEffect(e2)
	--activate field
	yume.AddYumeFieldGlobal(c,71400058,1)
end
function c71400058.filtercon1a(c,tp)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER)
end
function c71400058.con1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c71400058.filtercon1,1,nil,tp)
end
function c71400058.con1b(e,tp,eg,ep,ev,re,r,rp)
	local attr=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_ATTRIBUTE)
	return re:IsActiveType(TYPE_MONSTER) and attr&ATTRIBUTE_WATER>0
end
function c71400058.filterc1(c)
	return c:IsSetCard(0xb714) and c:IsType(TYPE_FIELD) and c:IsAbleToGraveAsCost()
end
function c71400058.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400058.filterc1,tp,LOCATION_DECK,0,1,nil) end
	local g=Duel.GetMatchingGroup(c71400058.filterc1,tp,LOCATION_DECK,0,nil)
	local ct=g:GetClassCount(Card.GetCode)
	if ct>4 then ct=4 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local sg=g:SelectSubGroup(tp,aux.dncheck,false,1,ct)
	Duel.SendtoGrave(sg,REASON_COST)
end
function c71400058.filter1(c)
	return c:IsSetCard(0x714) and c:IsXyzSummonable(nil)
end
function c71400058.tg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400058.filter1,tp,LOCATION_EXTRA,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c71400058.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c71400058.filter1,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		Duel.XyzSummon(tp,tc,nil)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SPSUMMON_COST)
		e1:SetLabelObject(c)
		e1:SetOperation(c71400058.regop)
		tc:RegisterEffect(e1)
	end
end
function c71400058.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lc=e:GetLabelObject()
	local e1=Effect.CreateEffect(lc)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
	e1:SetDescription(aux.Stringid(71400058,2))
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(lc)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CANNOT_TRIGGER)
	e2:SetReset(RESET_EVENT+0xff0000+RESET_PHASE+PHASE_END)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e3:SetValue(1)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_BATTLE_TARGET)
	c:RegisterEffect(e4)
	e:Reset()
end
function c71400058.con2(e,tp,eg,ep,ev,re,r,rp)
	return tp==Duel.GetTurnPlayer()
end
function c71400058.filter2(c)
	return c:IsFaceup() and c:IsSetCard(0x714) and c:IsType(TYPE_XYZ)
end
function c71400058.filter2a(c)
	return c:IsSetCard(0xb714) and c:IsType(TYPE_FIELD) and c:IsCanOverlay()
end
function c71400058.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c71400058.filter2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingMatchingCard(c71400058.filter2a,tp,LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c71400058.filter2a,tp,LOCATION_GRAVE,0,nil)
	Duel.SetOperationInfo(0,CATEGORY_LEAVE_GRAVE,g,1,tp,LOCATION_GRAVE)
end
function c71400058.op2(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c71400058.filter2,tp,LOCATION_MZONE,0,1,1,nil):GetFirst()
	local g=Duel.SelectMatchingCard(tp,c71400058.filter2a,tp,LOCATION_GRAVE,0,1,1,nil)
	if tc:IsRelateToEffect(e) and not tc:IsImmuneToEffect(e) then
		Duel.Overlay(tc,g)
	end
end