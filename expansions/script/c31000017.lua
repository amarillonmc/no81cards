--Fallacio Witch Hunt
function c31000017.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,31000017+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(c31000017.target)
	e1:SetOperation(c31000017.activate)
	c:RegisterEffect(e1)
end 

function c31000017.spfilter(c,lv,e,tp)
	return c:IsSetCard(0x308) and c:IsLevel(lv) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function c31000017.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local lv=1
	local list={}
	while lv<=6 do
		local b1=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
			and Duel.IsPlayerCanSpecialSummonMonster(tp,31000002,0,TYPES_TOKEN_MONSTER,0,0,lv,RACE_PSYCHIC,ATTRIBUTE_DARK,POS_FACEUP,1-tp)
		local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
			and Duel.IsExistingMatchingCard(c31000017.spfilter,tp,LOCATION_DECK,0,1,nil,lv,e,tp)
		if b1 or b2 then table.insert(list,lv) end
		lv=lv+1
	end
	if chk==0 then return #list end
	lv=Duel.AnnounceNumber(tp,table.unpack(list))
	e:SetLabel(lv)
end

function c31000017.activate(e,tp,eg,ep,ev,re,r,rp)
	local op=0
	local c=e:GetHandler()
	local fid=c:GetFieldID()
	local lv=e:GetLabel()
	local b1=Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,31000002,0,TYPES_TOKEN_MONSTER,0,0,lv,RACE_PSYCHIC,ATTRIBUTE_DARK,POS_FACEUP,1-tp)
	local b2=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 
		and Duel.IsExistingMatchingCard(c31000017.spfilter,tp,LOCATION_DECK,0,1,nil,lv,e,tp)
	if b1 and b2 then op=Duel.SelectOption(tp,aux.Stringid(31000017,0),aux.Stringid(31000017,1))
	elseif b1 then op=Duel.SelectOption(tp,aux.Stringid(31000017,0))
	elseif b2 then op=Duel.SelectOption(tp,aux.Stringid(31000017,1))+1
	else return end
	if op==0 then
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
		if Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0 then
			Duel.SpecialSummon(token,0,tp,1-tp,false,false,POS_FACEUP) end
	else
		local g=Duel.GetMatchingGroup(c31000017.spfilter,tp,LOCATION_DECK,0,nil,lv,e,tp)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		local tc=sg:GetFirst()
		if tc then Duel.IsPlayerCanSpecialSummon(tp,0,POS_FACEUP,tp,tc)
			Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_CANNOT_ATTACK_ANNOUNCE)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e1)
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE)
			e2:SetCode(EFFECT_DISABLE)
			e2:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e2)
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetCode(EFFECT_DISABLE_EFFECT)
			e3:SetValue(RESET_TURN_SET)
			e3:SetReset(RESET_EVENT+RESETS_STANDARD)
			tc:RegisterEffect(e3)
			tc:RegisterFlagEffect(31000017,RESET_EVENT+RESETS_STANDARD,0,1,fid)
		end
	end
end