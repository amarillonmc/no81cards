if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
local s,id,o=GetID()
function s.initial_effect(c)
	SNNM.Excavated_Check(c)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetLabel(0x2,0)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetTarget(s.reptg2)
	e2:SetValue(s.repval)
	c:RegisterEffect(e2)
end
function s.filter(c,e,tp,eff)
	return c:IsAttack(0) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (Duel.IsCanAddCounter(tp,0x153f,2,c) or eff==0)
end
function s.ctfilter(c)
	return c:GetOriginalType()&TYPE_MONSTER~=0 and c:IsSetCard(0x5534) and c:IsCanAddCounter(0x153f,2)
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chkc then return chkc:IsOnField() and chkc:IsControler(tp) and s.ctfilter(chkc) end
	if chk==0 then
		local loc=(e:GetHandler():GetFlagEffect(53766099)>0 and 0x3) or 0x2
		e:SetLabel(loc,0)
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsExistingMatchingCard(s.filter,tp,loc,0,1,nil,e,tp,0)
	end
	local sloc,eff=e:GetLabel()
	if Duel.IsExistingMatchingCard(s.filter,tp,sloc,0,1,nil,e,tp,1) and Duel.IsExistingTarget(s.ctfilter,tp,LOCATION_ONFIELD,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_COUNTER)
		Duel.SelectTarget(tp,s.ctfilter,tp,LOCATION_ONFIELD,0,1,1,nil)
		e:SetLabel(sloc,1)
		Duel.SetOperationInfo(0,CATEGORY_COUNTER,nil,4,0,0x153f)
	else
		e:SetProperty(0)
		e:SetLabel(sloc,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,sloc)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	local loc,eff=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sc=Duel.SelectMatchingCard(tp,s.filter,tp,loc,0,1,1,nil,e,tp,0):GetFirst()
	local tg=Duel.GetTargetsRelateToChain()
	local tc=(tg and tg:GetFirst()) or nil
	if sc and Duel.SpecialSummon(sc,0,tp,tp,false,false,POS_FACEUP)~=0 and eff==1 and sc:IsLocation(LOCATION_ONFIELD) and sc:IsFaceup() and sc:IsCanAddCounter(0x153f,2) and tc and tc:IsCanAddCounter(0x153f,2) then
		local g=Group.FromCards(tc,sc)
		for c in aux.Next(g) do
			c:AddCounter(0x153f,2)
			if c:GetFlagEffect(53766000)==0 and not c:IsImmuneToEffect(e) then
				local e1=Effect.CreateEffect(c)
				e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
				e1:SetCode(EFFECT_DESTROY_REPLACE)
				e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
				e1:SetTarget(s.reptg)
				e1:SetOperation(s.repop)
				e1:SetReset(RESET_EVENT+RESETS_STANDARD)
				c:RegisterEffect(e1,true)
				c:RegisterFlagEffect(53766000,RESET_EVENT+RESETS_STANDARD,0,0)
			end
		end
	end
end
function s.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE) and c:IsCanRemoveCounter(tp,0x153f,1,REASON_EFFECT) end
	return Duel.SelectEffectYesNo(tp,c,aux.Stringid(id,0))
end
function s.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0x153f,1,REASON_EFFECT)
end
function s.repfilter(c,tp)
	return c:IsLocation(LOCATION_ONFIELD) and c:IsControler(tp) and c:IsFaceup() and c:GetBaseAttack()==0 and c:GetOriginalType()&TYPE_MONSTER~=0 and not c:IsReason(REASON_REPLACE)
end
function s.reptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsAbleToRemove() and eg:IsExists(s.repfilter,1,nil,tp) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
		return true
	else return false end
end
function s.repval(e,c)
	return s.repfilter(c,e:GetHandlerPlayer())
end
