--纯真的模范·阿纪尔
local cm,m,o=GetID()
function cm.initial_effect(c)
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFlagEffect(tp,70002380)==0 then
		--spsm
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SPSUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(cm.spcon)
		e1:SetOperation(cm.spop)
		Duel.RegisterEffect(e1,tp)
		--spsm
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
		e1:SetCondition(cm.spcon)
		e1:SetOperation(cm.spop)
		Duel.RegisterEffect(e1,tp)
		Duel.RegisterFlagEffect(tp,70002380,RESET_PHASE+PHASE_END,0,1000)
	end
end
function cm.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsSetCard(0x6a9)
end
function cm.filter(c,e,tp,s)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:IsSetCard(0x6a9) and c:IsLevelBelow(s)
end
function cm.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.cfilter,1,nil,tp)
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local i=Duel.GetFlagEffect(tp,m)
	if i/2==math.floor(i/2) and i<=7 then
		local s=Duel.GetFlagEffect(tp,60002257)
		if Duel.IsExistingMatchingCard(cm.filter,tp,LOCATION_EXTRA,0,1,nil,e,tp,s) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and s>=1 then
			local op=0
			op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
			if op==0 then
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=Duel.SelectMatchingCard(tp,cm.filter,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,s)
				if g:GetCount()>0 then
					Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
					Duel.ResetFlagEffect(tp,60002257)
				end
			elseif op==1 then
				Duel.RegisterFlagEffect(tp,60002257,RESET_PHASE+PHASE_END,0,1000)
			end
		else
			Duel.RegisterFlagEffect(tp,60002257,RESET_PHASE+PHASE_END,0,1000)
		end 
	elseif i/2~=math.floor(i/2) and i<=7 then
		Duel.Draw(tp,1,REASON_EFFECT)
	end
	Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
end
