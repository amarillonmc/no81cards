--极翼灵兽 德尔塔气流
function c45745921.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,45745921+EFFECT_COUNT_CODE_OATH)
	c:RegisterEffect(e1)
	--avoid battle damage
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_AVOID_BATTLE_DAMAGE)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(aux.TargetBoolFunction(Card.IsRace,RACE_WINDBEAST))
	e2:SetValue(1)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(45745921,0))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_CHAINING)
	e3:SetProperty(EFFECT_FLAG_DELAY)
	e3:SetRange(LOCATION_FZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(c45745921.spcon)
	e3:SetTarget(c45745921.sctg)
	e3:SetOperation(c45745921.scop)
	c:RegisterEffect(e3)  
	--spsummon

	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(45745921,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O+EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetRange(LOCATION_FZONE)
	e4:SetCountLimit(1)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCondition(c45745921.spcon1)
	e4:SetTarget(c45745921.sctg1)
	e4:SetOperation(c45745921.scop1)
	c:RegisterEffect(e4)

	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetCode(45745921)
	e5:SetRange(LOCATION_FZONE)
	e5:SetTargetRange(1,0)
	c:RegisterEffect(e5)
end
--e3
function c45745921.spcon(e,tp,eg,ep,ev,re,r,rp)
	return re:IsActiveType(TYPE_MONSTER) and re:GetHandler():IsSetCard(0x881) and re:GetHandler():IsLocation(LOCATION_MZONE)
end
function c45745921.sctg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)  
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end  
function c45745921.scop(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)  
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)  
	if g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)  
	end  
end
--E4
function c45745921.cfilter1(c)
	return c:IsFaceup() and c:IsSetCard(0x881)
end
function c45745921.spcon1(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c45745921.cfilter1,1,nil)
end
function c45745921.sctg1(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then  
		local mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)  
		return Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)  
	end  
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA) 
end  
function c45745921.scop1(e,tp,eg,ep,ev,re,r,rp)  
	if not e:GetHandler():IsRelateToEffect(e) then return end  
	local mg=Duel.GetMatchingGroup(nil,tp,LOCATION_MZONE,0,nil)  
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)  
	if g:GetCount()>0 then  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)  
		local sg=g:Select(tp,1,1,nil)  
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)  
	end  
end