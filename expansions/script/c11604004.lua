--宝可·大师球
local s,id,o=GetID()
function s.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_TOEXTRA+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE)		
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(TIMINGS_CHECK_MONSTER)
	e1:SetCountLimit(1,id+EFFECT_COUNT_CODE_DUEL)
	e1:SetCondition(s.condition)
	e1:SetTarget(s.target)
	e1:SetOperation(s.activate)
	c:RegisterEffect(e1)
	if not s.global_check then
		s.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CHAINING)
		ge1:SetOperation(s.checkop)
		Duel.RegisterEffect(ge1,0)
	end	
end
function s.checkop(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	while tc do
		if tc:IsSetCard(0x9224) and tc:IsType(TYPE_QUICKPLAY) and rp==tp  then
			if Duel.GetFlagEffect(rp,id)~=0 then
				for _,i in ipairs{Duel.GetFlagEffectLabel(rp,id)} do
					if i==tc:GetCode() then return end  
				end
			end				
			Duel.RegisterFlagEffect(rp,id,0,0,0,tc:GetCode())
		end
		tc=eg:GetNext()
	end
end
function s.condition(e,tp,eg,ep,ev,re,r,rp)
	local set={Duel.GetFlagEffectLabel(tp,id)}
	return (#set)>=5 --Duel.GetFlagEffect(e:GetHandlerPlayer(),id)>4
end
function s.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_MZONE,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_MZONE,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOEXTRA+CATEGORY_TOHAND,g,1,1-tp,LOCATION_MZONE)
end
function s.activate(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPERATECARD)
	local g=Duel.SelectMatchingCard(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		local tc=g:GetFirst()		
		Duel.SendtoHand(tc,tp,REASON_RULE,1-tp)
		if tc:IsLocation(LOCATION_EXTRA+LOCATION_HAND) and tc:IsCanBeSpecialSummoned(e,0,tp,true,false) and (tc:IsLocation(LOCATION_HAND) and Duel.GetMZoneCount(tp)>0
			or tc:IsLocation(LOCATION_EXTRA) and Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0) and Duel.SelectYesNo(tp,aux.Stringid(id,1)) then
			Duel.BreakEffect()
			Duel.SpecialSummon(tc,0,tp,tp,true,false,POS_FACEUP)
		end	
	end
end
