--战域投影 菲米莉丝
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,75646600)
	--link summon
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkType,TYPE_EFFECT),2,99,s.lcheck)
	c:EnableReviveLimit()
	--pierce
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_PIERCE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,0)
	e1:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_CYBERSE))
	e1:SetValue(DOUBLE_DAMAGE)
	c:RegisterEffect(e1)
	--disable summon
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_DISABLE_SUMMON+CATEGORY_DESTROY+CATEGORY_DRAW)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_SUMMON)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCondition(s.condition)
	e2:SetCost(s.cost)
	e2:SetTarget(s.target)
	e2:SetOperation(s.activate)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON)
	c:RegisterEffect(e4)
	--equip(self)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(id,1))
	e5:SetCategory(CATEGORY_EQUIP)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,id-70000000)
	e5:SetTarget(s.eqstg)
	e5:SetOperation(s.eqsop)
	c:RegisterEffect(e5)
	--effect grant
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_GRANT)
	e6:SetRange(LOCATION_SZONE)
	e6:SetTargetRange(LOCATION_MZONE,0)
	e6:SetTarget(s.eftg)
	e6:SetLabelObject(e1)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e6:SetLabelObject(e2)
	c:RegisterEffect(e7)
	local e8=e7:Clone()
	e8:SetLabelObject(e3)
	c:RegisterEffect(e8)
	local e9=e8:Clone()
	e9:SetLabelObject(e4)
	c:RegisterEffect(e9)
end
function s.lcheck(g)
	return g:IsExists(Card.IsLinkRace,1,nil,RACE_CYBERSE)
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetCurrentChain()==0
end
function s.costfilter(c,tp)
	if c:IsLocation(LOCATION_HAND) then return c:IsDiscardable() end
	return c:IsAbleToRemoveAsCost() and c:IsHasEffect(75646628,tp)
end
function s.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,tp) end
	local g=Duel.GetMatchingGroup(s.costfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,nil,tp)   
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local tc=g:Select(tp,1,1,e:GetHandler()):GetFirst()
	local te=tc:IsHasEffect(75646628,tp)
	if te then
		e:SetLabel(1)
		Duel.Remove(tc,POS_FACEUP,REASON_COST)
	elseif tc:IsCode(75646600) or tc:IsRace(RACE_CYBERSE) then e:SetLabel(1)
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	else 
		e:SetLabel(0)
		Duel.SendtoGrave(tc,REASON_COST+REASON_DISCARD)
	end
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	if (e:GetLabel()==1 or Duel.GetFlagEffect(tp,75646600)>0) then
		Duel.SetOperationInfo(0,CATEGORY_DISABLE_SUMMON,eg,eg:GetCount(),0,0)
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,eg:GetCount(),0,0)
	end
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	if Duel.Draw(p,d,REASON_EFFECT)>0 and (e:GetLabel()==1 or Duel.GetFlagEffect(tp,75646600)>0) then
		Duel.NegateSummon(eg)
		Duel.Destroy(eg,REASON_EFFECT)
	end
end
function s.eqlimit(e,c)
	return e:GetOwner()==c
end
function s.eqfilter(c)
	return c:IsFaceup() and c:IsRace(RACE_CYBERSE)
end
function s.eqstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and s.eqfilter(chkc) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingTarget(s.eqfilter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	Duel.SelectTarget(tp,s.eqfilter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,e:GetHandler(),1,0,0)
end
function s.eqsop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		Duel.Equip(tp,c,tc)
		--Add Equip limit
		local e1=Effect.CreateEffect(tc)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_EQUIP_LIMIT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		e1:SetValue(s.eqlimit)
		c:RegisterEffect(e1)
		local e2=Effect.CreateEffect(c)
		e2:SetType(EFFECT_TYPE_EQUIP)
		e2:SetCode(EFFECT_UPDATE_ATTACK)
		e2:SetValue(1000)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e2)
		local e3=e2:Clone()
		e3:SetCode(EFFECT_UPDATE_DEFENSE)
		c:RegisterEffect(e3)
		c:RegisterFlagEffect(id,RESET_EVENT+RESETS_STANDARD,0,0)
		--tc:CopyEffect(id,RESET_EVENT+RESETS_STANDARD)
	end
end
function s.eftg(e,c)
	local cc=e:GetHandler()
	return cc:GetEquipTarget()==c and cc:GetFlagEffect(id)>0
end