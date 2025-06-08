--晶导算使 逻辑与门
if not require and loadfile then
	function require(str)
		require_list=require_list or {}
		if not require_list[str] then
			if string.find(str,"%.") then
				require_list[str]=loadfile(str)
			else
				require_list[str]=loadfile(str..".lua")
			end
			require_list[str]()
			return require_list[str]
		end
		return require_list[str]
	end
end
xpcall(function() require("expansions/script/c33201401") end,function() require("script/c33201401") end)
function c33201405.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	VHisc_JDSS.addcheck(c)
	--pendulum set
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_IGNITION)
	e0:SetRange(LOCATION_PZONE)
	e0:SetCountLimit(1,32201405)
	e0:SetCondition(c33201405.tdcon1)
	e0:SetTarget(c33201405.sptg)
	e0:SetOperation(c33201405.spop)
	c:RegisterEffect(e0) 
	local e5=e0:Clone()
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e5:SetCondition(c33201405.tdcon2)
	c:RegisterEffect(e5)
	--spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCountLimit(1,33201405+10000)
	e1:SetCondition(c33201405.sdcon)
	e1:SetTarget(c33201405.sdtg)
	e1:SetOperation(c33201405.sdop)
	c:RegisterEffect(e1) 
	--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(33201405,2))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCountLimit(1,33201405+20000)
	e1:SetCondition(c33201405.descon)
	e1:SetTarget(c33201405.destg)
	e1:SetOperation(c33201405.desop)
	c:RegisterEffect(e1)   
end
c33201405.SetCard_JDSS=true 
function c33201405.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return not Duel.IsPlayerAffectedByEffect(tp,33201408)
end
function c33201405.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return aux.dscon() and Duel.IsPlayerAffectedByEffect(tp,33201408)
end
function c33201405.cfilter1(c,e,tp,scale)
	return c.SetCard_JDSS and c:GetLeftScale()==scale and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c33201405.pencon(e,tp,eg,ep,ev,re,r,rp)
	local scale=e:GetHandler():GetLeftScale()
	return Duel.IsExistingMatchingCard(c33201405.cfilter1,tp,LOCATION_PZONE,0,1,e:GetHandler(),e,tp,scale)
end
function c33201405.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local scale=e:GetHandler():GetLeftScale()
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c33201405.cfilter1,tp,LOCATION_PZONE,0,1,c,e,tp,scale) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c33201405.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local scale=e:GetHandler():GetLeftScale()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c33201405.cfilter1,tp,LOCATION_PZONE,0,1,1,c,e,tp,scale)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
--
function c33201405.c3filter(c)  
	return c:IsType(TYPE_PENDULUM) and c:IsFaceup()
end 
function c33201405.sdcon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c33201405.c3filter,e:GetHandlerPlayer(),LOCATION_PZONE,0,nil)
	if g:GetCount()~=2 then return false end
	local cc=g:GetFirst()
	local lsc=cc:GetLeftScale()
	local dc=g:GetNext()
	local l2sc=dc:GetLeftScale()
	return lsc==l2sc  and Duel.GetLocationCount(e:GetHandlerPlayer(),LOCATION_MZONE)>0 
end
function c33201405.sdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) and Duel.IsExistingMatchingCard(Card.IsAbleToHand,tp,LOCATION_PZONE,0,1,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_PZONE)
end
function c33201405.sdop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	if Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)~=0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tc=Duel.SelectMatchingCard(tp,Card.IsAbleToHand,tp,LOCATION_PZONE,0,1,1,e:GetHandler()):GetFirst()
		if tc then
			Duel.SendtoHand(tc,nil,REASON_EFFECT)
		end
	end
end
--
function c33201405.cfilter(c,scale)
	return c:IsFaceup() 
		and c.SetCard_JDSS and c:GetLeftScale()==scale
end
function c33201405.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local scale=c:GetLeftScale()
	return eg:IsExists(c33201405.cfilter,1,c,scale) and re and re:GetHandler().SetCard_JDSS 
end
function c33201405.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c33201405.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,nil)
	if #g>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
	end
end
