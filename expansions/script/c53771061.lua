--通常魔法2
if not require and dofile then function require(str) return dofile(str..".lua") end end
if not pcall(function() require("expansions/script/c53702500") end) then require("script/c53702500") end
function c53771061.initial_effect(c)
	SNNM.Sarcoveil_Sort(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DICE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c53771061.target)
	e1:SetOperation(c53771061.activate)
	c:RegisterEffect(e1)
	--spsummon
	local custom_code=aux.RegisterMergedDelayedEvent_ToSingleCard(c,53771061,EVENT_LEAVE_FIELD)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(53771061,0))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(custom_code)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,53771061)
	e2:SetCondition(c53771061.spcon)
	e2:SetCost(aux.bfgcost)
	e2:SetTarget(c53771061.sptg)
	e2:SetOperation(c53771061.spop)
	c:RegisterEffect(e2)
	--
	if not c53771061.global_check then
		c53771061.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_TO_GRAVE)
		ge1:SetOperation(c53771061.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c53771061.checkop(e,tp,eg,ep,ev,re,r,rp)
	for tc in aux.Next(eg) do
		if tc:IsPreviousLocation(LOCATION_HAND) and tc:IsSetCard(0xa53b) then
			Duel.RegisterFlagEffect(tc:GetPreviousControler(),53771061,RESET_PHASE+PHASE_END,0,1)
		end
	end
end
function c53771061.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local ct=Duel.GetFlagEffect(tp,53771061)
	if chk==0 then return ct>0 end
	Duel.SetOperationInfo(0,CATEGORY_DICE,nil,0,tp,ct)
end
function c53771061.activate(e,tp,eg,ep,ev,re,r,rp)
	local ct=Duel.GetFlagEffect(tp,53771061)
	for i=1,ct do
		local d=Duel.TossDice(tp,1)
		while d==6 do d=Duel.TossDice(tp,1) end
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_SET_POSITION)
		e1:SetTargetRange(0,LOCATION_MZONE)
		e1:SetTarget(c53771061.postg)
		e1:SetValue(POS_FACEDOWN_DEFENSE)
		e1:SetLabel(d)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
end
function c53771061.postg(e,c)
	return c:GetSequence()<5 and c:GetSequence()==e:GetLabel()-1
end
function c53771061.chkfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_MZONE) and c:GetReasonPlayer()==1-tp and not c:IsReason(REASON_RULE)
end
function c53771061.spcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c53771061.chkfilter,1,nil,tp)
end
function c53771061.spfilter(c,e,tp,chk)
	return c:IsSetCard(0xa53b) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and (chk==0 or aux.NecroValleyFilter()(c))-- and Duel.GetLocationCountFromEx(tp,tp,nil,c)>0
end
function c53771061.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetMZoneCount(tp)>0
		and Duel.IsExistingMatchingCard(c53771061.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp,0)
	end
	e:SetLabel(eg:FilterCount(c53771061.chkfilter,nil,tp))
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND+LOCATION_GRAVE)
end
function c53771061.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetMZoneCount(tp)<=0 then return end
	local ft=Duel.IsPlayerAffectedByEffect(tp,59822133) and Duel.GetMZoneCount(tp) or 1
	local ct=math.min(ft,e:GetLabel())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local sg=Duel.SelectMatchingCard(tp,c53771061.spfilter,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,ct,nil,e,tp,1)
	if #sg>0 then
		Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
	end
end
