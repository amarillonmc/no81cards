--Fallacio Strawman
function c31000001.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetCountLimit(1,31000001)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(c31000001.spcon)
	e1:SetTarget(c31000001.sptg)
	e1:SetOperation(c31000001.spop)
	c:RegisterEffect(e1)
	--SP Search
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_TOKEN+CATEGORY_SEARCH)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,31000002)
	e2:SetCost(c31000001.cost)
	e2:SetTarget(c31000001.target)
	e2:SetOperation(c31000001.operation)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e3)
	local e4=e2:Clone()
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCountLimit(1)
	e5:SetCondition(c31000001.sycon)
	c:RegisterEffect(e5)
end

function c31000001.spcon(e,tp,eg,ep,ev,re,r,rp)
	local spfilter=function(c)
		return c:IsCode(31000002) and c:IsLevel(e:GetHandler():GetLevel())
	end
	return Duel.IsExistingMatchingCard(spfilter,tp,nil,LOCATION_MZONE,1,nil)
end

function c31000001.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and e:GetHandler():IsCanBeSpecialSummoned(e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,tp,0)
end

function c31000001.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)
	end
end

function c31000001.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local lv=Duel.AnnounceLevel(tp,1,6)
	e:SetLabel(lv)
end

function c31000001.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=e:GetLabel()
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,31000002,0,TYPES_TOKEN_MONSTER,0,0,lv,RACE_PSYCHIC,ATTRIBUTE_DARK,POS_FACEUP,1-tp) end
	Duel.SetOperationInfo(0,CATEGORY_TOKEN,nil,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,0,0)
end

function c31000001.operation(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lv=e:GetLabel()
	local token=Duel.CreateToken(tp,31000002)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(lv)
	token:RegisterEffect(e1,true)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_UNRELEASABLE_SUM)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(1)
	token:RegisterEffect(e2,true)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_UNRELEASABLE_NONSUM)
	token:RegisterEffect(e3,true)
	local e4=e2:Clone()
	e4:SetCode(EFFECT_CANNOT_BE_FUSION_MATERIAL)
	token:RegisterEffect(e4,true)
	local e5=e2:Clone()
	e5:SetCode(EFFECT_CANNOT_BE_SYNCHRO_MATERIAL)
	token:RegisterEffect(e5,true)
	local e6=e2:Clone()
	e6:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
	token:RegisterEffect(e6,true)
	if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 and Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP)>0 then
		local filter=function(c)
			return c:IsSetCard(0x308) and c:IsLevel(lv) and c:IsAbleToHand()
		end
		local g=Duel.GetMatchingGroup(filter,tp,LOCATION_DECK,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(31000001,0)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
			local sg=g:Select(tp,1,1,nil)
			local tc=sg:GetFirst()
			if tc and Duel.IsPlayerCanSendtoHand(tp,tc) then
				Duel.SendtoHand(sg,tp,REASON_EFFECT)
				Duel.ConfirmCards(1-tp,sg)
			end
		end
	end
end

function c31000001.sycon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsType(TYPE_SYNCHRO)
end
