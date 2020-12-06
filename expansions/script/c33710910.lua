--梦幻联动 ～双厨狂喜～
function c33710910.initial_effect(c)
	--Active
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_BATTLE_START+TIMING_BATTLE_END)
	e1:SetCondition(c33710910.thcon)
	e1:SetTarget(c33710910.thtg)
	e1:SetOperation(c33710910.thop)
	c:RegisterEffect(e1) 
end
function c33710910.thcon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	return ph>=PHASE_BATTLE_START and ph<=PHASE_BATTLE and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
end
function c33710910.spfilter(c,e,tp,g)
	return c:IsCanBeSpecialSummoned(e,0,tp,true,false) and g:IsExists(Card.IsCode,1,nil,c:GetCode()) and ((c:IsType(TYPE_LINK+TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0) or (Duel.GetLocationCount(tp,LOCATION_MZONE)>0  and not (c:IsType(TYPE_LINK+TYPE_PENDULUM) and c:IsLocation(LOCATION_EXTRA)))) 
end
function c33710910.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
	if chk==0 then return Duel.IsExistingMatchingCard(c33710910.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,1,nil,e,tp,g) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,nil,0,0)
end
function c33710910.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ggg=Duel.GetMatchingGroup(Card.IsFaceup,1-tp,LOCATION_MZONE,0,nil)
	local g=Duel.GetMatchingGroup(c33710910.spfilter,tp,LOCATION_DECK+LOCATION_EXTRA,0,nil,e,tp,ggg)
	while g:GetCount()>0 do
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		g:RemoveCard(tc)
		if Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)~=0 then
			local fid=c:GetFieldID()
			tc:RegisterFlagEffect(33710910,RESET_EVENT+RESETS_STANDARD,0,1,fid)
			local e3=Effect.CreateEffect(c)
			e3:SetDescription(aux.Stringid(33710910,5))
			e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
			e3:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
			e3:SetCode(EVENT_PHASE+PHASE_END)
			e3:SetCountLimit(1)
			e3:SetLabel(fid)
			e3:SetLabelObject(tc)
			e3:SetCondition(c33710910.thcon1)
			e3:SetOperation(c33710910.thop1)
			Duel.RegisterEffect(e3,tp)
			Duel.SpecialSummonComplete()
			g=g:Filter(c33710910.spfilter,nil,e,tp,ggg)
		end
	end
end
function c33710910.thcon1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:GetFlagEffectLabel(33710910)==e:GetLabel() then
		return true
	else
		e:Reset()
		return false
	end
end
function c33710910.thop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	Duel.SendtoHand(tc,tp,REASON_EFFECT)
end