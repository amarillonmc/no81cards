--个人行动-青色怒火
function c79029479.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetOperation(c79029479.activate)
	c:RegisterEffect(e1) 
	--SpecialSummon
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_FZONE) 
	e2:SetCountLimit(1,79029479)  
	e2:SetCost(c79029479.spcost)
	e2:SetTarget(c79029479.sptg)
	e2:SetOperation(c79029479.spop)
	c:RegisterEffect(e2)
	--negate
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DISABLE+CATEGORY_POSITION)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_CHAIN_SOLVING)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c79029479.negcon)
	e3:SetOperation(c79029479.negop)
	c:RegisterEffect(e3)
end
function c79029479.thfilter(c)
	return c:IsCode(29065574) and c:IsAbleToHand()
end
function c79029479.activate(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c79029479.thfilter,tp,LOCATION_DECK,0,nil)
	if g:GetCount()>0 and Duel.CheckLPCost(tp,2000) and Duel.SelectYesNo(tp,aux.Stringid(79029479,0)) then
		Debug.Message("“如果战斗不可避免......”这是以前我最信任的人教给我的话。")
		Duel.Hint(HINT_SOUND,0,aux.Stringid(79029479,2))   
		Duel.PayLPCost(tp,2000)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c79029479.ctfil(c)
	return c:IsCode(29065574) and c:IsAbleToGraveAsCost() 
end
function c79029479.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029479.ctfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,nil) end
	local g=Duel.SelectMatchingCard(tp,c79029479.ctfil,tp,LOCATION_HAND+LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c79029479.xxfil(c,e,tp)
	local lk=c:GetLink()
	return Duel.IsExistingMatchingCard(c79029479.spfil,tp,LOCATION_EXTRA,0,1,nil,e,tp,lk)
end
function c79029479.spfil(c,e,tp,lk)
	return c:IsLinkBelow(lk) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_LINK,tp,false,false) and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c79029479.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c79029479.xxfil,tp,LOCATION_MZONE,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end

function c79029479.spop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c79029479.xxfil,tp,LOCATION_MZONE,0,nil,e,tp)
	if g:GetCount()<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	local tc=Duel.SelectMatchingCard(tp,c79029479.xxfil,tp,LOCATION_MZONE,0,1,1,nil,e,tp):GetFirst()
	local lk=tc:GetLink()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local tc1=Duel.SelectMatchingCard(tp,c79029479.spfil,tp,LOCATION_EXTRA,0,1,1,nil,e,tp,lk):GetFirst()
		Duel.SpecialSummonStep(tc1,SUMMON_TYPE_LINK,tp,tp,false,false,POS_FACEUP)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc1:RegisterEffect(e1,true)
		local e2=Effect.CreateEffect(e:GetHandler())
		e2:SetType(EFFECT_TYPE_SINGLE)
		e2:SetCode(EFFECT_DISABLE_EFFECT)
		e2:SetReset(RESET_EVENT+RESETS_STANDARD)
		tc:RegisterEffect(e2,true)
		tc1:CompleteProcedure()
		Duel.SpecialSummonComplete()
		if tc1:IsCode(79029359) then
		Debug.Message("这里是阿米娅。")
		Duel.Hint(HINT_SOUND,0,aux.Stringid(79029479,4))		 
		elseif tc1:IsCode(79029480) then 
		Debug.Message("这里是陈。")
		Duel.Hint(HINT_SOUND,0,aux.Stringid(79029479,5)) 
		else
		Debug.Message("行动开始。我们走！")
		Duel.Hint(HINT_SOUND,0,aux.Stringid(79029479,3)) 
		end
end
function c79029479.cfilter(c)
	return c:IsLinkAbove(6) and c:IsSetCard(0xa900)
end
function c79029479.negcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c79029479.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and rp==1-tp and Duel.IsChainDisablable(ev)
		and e:GetHandler():GetFlagEffect(79029479)<=0
end
function c79029479.negop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if Duel.SelectYesNo(tp,aux.Stringid(79029479,1)) then
		Debug.Message("不要......不要惹恼我。")
		Duel.Hint(HINT_SOUND,0,aux.Stringid(79029479,6)) 
		Duel.Hint(HINT_CARD,0,79029479)
		Duel.NegateEffect(ev)
		e:GetHandler():RegisterFlagEffect(79029479,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	end
end








