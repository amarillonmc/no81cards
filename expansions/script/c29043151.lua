--方舟骑士团-爱丽丝
local s,id,o=GetID()
function s.initial_effect(c)
	aux.AddCodeList(c,29065532)
	c:EnableReviveLimit()
	--COPY 
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,id)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(s.cpcost)
	e1:SetTarget(s.cptg)
	e1:SetOperation(s.cpop)
	c:RegisterEffect(e1)
	--
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_MSET)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id+1)
	e2:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e2:SetTarget(s.settg)
	e2:SetOperation(s.setop)
	c:RegisterEffect(e2)
end
function s.cpfilter(c)
	return (((c:IsSetCard(0x87af) or (_G["c"..c:GetCode()] and  _G["c"..c:GetCode()].named_with_Arknight)) and c:GetType()==TYPE_SPELL+TYPE_RITUAL) or (c:IsSetCard(0x57af) and (c:GetType()==TYPE_SPELL or c:GetType()==TYPE_TRAP))) and c:IsAbleToGraveAsCost()
		and c:CheckActivateEffect(true,true,false)~=nil
end
function s.cpcost(e,tp,eg,ep,ev,re,r,rp,chk)
	e:SetLabel(100)
	if chk==0 then return true end
end
function s.cptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then
		if e:GetLabel()~=100 then return false end
		e:SetLabel(0)
		return c:IsAbleToDeckAsCost() and Duel.IsExistingMatchingCard(s.cpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,nil)
	end
	e:SetLabel(0)
	Duel.SendtoDeck(c,nil,SEQ_DECKSHUFFLE,REASON_COST)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,s.cpfilter,tp,LOCATION_HAND+LOCATION_DECK,0,1,1,nil)
	local te,ceg,cep,cev,cre,cr,crp=g:GetFirst():CheckActivateEffect(true,true,true)
	Duel.SendtoGrave(g,REASON_COST)
	e:SetProperty(te:GetProperty())
	local tg=te:GetTarget()
	if tg then tg(e,tp,ceg,cep,cev,cre,cr,crp,1) end
	te:SetLabelObject(e:GetLabelObject())
	e:SetLabelObject(te)
	Duel.ClearOperationInfo(0)
end
function s.cpop(e,tp,eg,ep,ev,re,r,rp)
	local te=e:GetLabelObject()
	if not te then return end
	e:SetLabelObject(te:GetLabelObject())
	local op=te:GetOperation()
	if op then op(e,tp,eg,ep,ev,re,r,rp) end
end
function s.cfilter(c)
	return c:IsReleasableByEffect() and c:IsType(TYPE_TOKEN)
end
function s.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function s.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(s.posfilter,tp,0,LOCATION_MZONE,1,nil) end
end
function s.setop(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetMatchingGroupCount(s.posfilter,tp,0,LOCATION_MZONE,nil)
	if ct>3 then ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RELEASE)
	local rg=Duel.SelectMatchingCard(tp,s.cfilter,tp,LOCATION_MZONE,0,1,ct,nil)
	if rg:GetCount()>0 then
		local rct=Duel.Release(rg,REASON_EFFECT)
		if rct>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
			local g=Duel.SelectMatchingCard(tp,s.posfilter,tp,0,LOCATION_MZONE,1,rct,nil)
			if #g>0 then
				Duel.HintSelection(g)
				Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
			end
		end
	end
end

