--单调世界
function c9310027.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e0)
	--disable spsummon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetTarget(c9310027.splimit)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_FZONE)
	e2:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetTargetRange(1,0)
	e2:SetTarget(c9310027.splimit)
	c:RegisterEffect(e2)
	--inactivatable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_CANNOT_DISEFFECT)
	e3:SetRange(LOCATION_FZONE)
	e3:SetValue(c9310027.effectfilter)
	c:RegisterEffect(e3)
	--change cost
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(9310027)
	e4:SetRange(LOCATION_FZONE)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,0)
	c:RegisterEffect(e4)
	--lv
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_IGNITION)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e5:SetRange(LOCATION_FZONE)
	e5:SetCountLimit(1,9310027)
	e5:SetTarget(c9310027.lvltg)
	e5:SetOperation(c9310027.lvlop)
	c:RegisterEffect(e5)
	--special summon
	local e6=Effect.CreateEffect(c)
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetProperty(EFFECT_FLAG_DELAY)
	e6:SetRange(LOCATION_FZONE)
	e6:SetCondition(c9310027.scon)
	e6:SetTarget(c9310027.sctg)
	e6:SetOperation(c9310027.scop)
	c:RegisterEffect(e6)
end
function c9310027.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return not (c:IsType(TYPE_TUNER) or c:IsOriginalCodeRule(9310061)
			or (c:IsLocation(LOCATION_SZONE) and c:GetOriginalType(TYPE_TUNER)))
end
function c9310027.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return tc:IsType(TYPE_TUNER)
end
function c9310027.filter(c)
	return c:IsType(TYPE_SYNCHRO) and c:IsType(TYPE_TUNER) and c:IsLevelAbove(8) and c:IsFaceup()
end
function c9310027.lvltg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c9310027.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c9310027.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c9310027.filter,tp,LOCATION_MZONE,0,1,1,nil)
end
function c9310027.spfilter(c,e,tp,sync,mg)
	return c:IsLocation(LOCATION_GRAVE) and c:IsControler(tp) 
			and mg:IsContains(c) and c:IsType(TYPE_TUNER)
			and bit.band(c:GetReason(),0x80008)==0x80008 and c:GetReasonCard()==sync
			and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP)
end
function c9310027.lvlop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsLevel(4) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EFFECT_CHANGE_LEVEL)
	e1:SetValue(4)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD)
	tc:RegisterEffect(e1)
	if ft<=0 then return end
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then ft=1 end
	local sg=Duel.GetMatchingGroup(aux.NecroValleyFilter(c9310027.spfilter),tp,LOCATION_GRAVE,0,nil,e,tp,tc,tc:GetMaterial())
	if sg:GetCount()>0 and tc:GetSummonType()==SUMMON_TYPE_SYNCHRO and Duel.SelectYesNo(tp,aux.Stringid(9310027,2)) then
		Duel.BreakEffect()
		local g=nil
		if sg:GetCount()>ft then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			g=sg:Select(tp,ft,ft,nil)
		else
			g=sg
		end
		if g:GetCount()>0 then
			Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
function c9310027.cfilter(c,tp)
	return c:IsSummonPlayer(tp) and c:IsPreviousLocation(LOCATION_EXTRA)
end
function c9310027.scon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c9310027.cfilter,1,nil,1-tp)
end
function c9310027.sctg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x3f91)
		return e:GetHandler():GetFlagEffect(9310027)==0 
				and Duel.IsExistingMatchingCard(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,1,nil,nil,mg)
	end
	e:GetHandler():RegisterFlagEffect(9310027,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c9310027.scop(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(Card.IsSetCard,tp,LOCATION_MZONE,0,nil,0x3f91)
	local g=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil,mg)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local sg=g:Select(tp,1,1,nil)
		Duel.SynchroSummon(tp,sg:GetFirst(),nil,mg)
	end
end
