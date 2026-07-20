--幽魔搬运者 凯尔

local s,id=GetID()
s.named_with_Darkling=1

s.COUNTER_DARKLING=0x2f1e
s.NYX_CODE=40021115

function s.Darkling(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Darkling
end

function s.initial_effect(c)
	c:EnableReviveLimit()
		aux.AddCodeList(c,40021115)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(s.Darkling),1)

	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(id,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(s.altcon)
	e0:SetTarget(s.alttg)
	e0:SetOperation(s.altop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)

	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,1))
	e1:SetCategory(CATEGORY_DAMAGE+CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCountLimit(1,id)
	e1:SetCondition(s.thcon1)
	e1:SetTarget(s.thtg)
	e1:SetOperation(s.thop)
	c:RegisterEffect(e1)
	
	local e2=e1:Clone()
	e2:SetCode(EVENT_TO_GRAVE)
	e2:SetCondition(s.thcon2)
	c:RegisterEffect(e2)

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(id,2))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetRange(LOCATION_GRAVE)
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetCountLimit(1,id+1)
	e3:SetCondition(s.spcon)
	e3:SetTarget(s.sptg)
	e3:SetOperation(s.spop)
	c:RegisterEffect(e3)
end

function s.ntfilter(c,sc,tp)
	return s.Darkling(c) and not c:IsType(TYPE_TUNER) and c:IsCanBeSynchroMaterial(sc)
		and c:IsFaceup() and c:IsControler(tp)
end

function s.altcon(e,c,og,lmat,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local lv=c:GetLevel()
	local mg=Duel.GetMatchingGroup(s.ntfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	return mg:IsExists(s.altcheck,1,nil,lv,tp)
end

function s.altcheck(c,lv,tp)
	local diff = lv - c:GetLevel()
	return diff>0 and Duel.IsCanRemoveCounter(tp,1,0,s.COUNTER_DARKLING,diff,REASON_COST)
		and Duel.GetLocationCountFromEx(tp,tp,c,c)>0
end

function s.alttg(e,tp,eg,ep,ev,re,r,rp,chk,c,og,lmat,min,max)
	local lv=c:GetLevel()
	local mg=Duel.GetMatchingGroup(s.ntfilter,tp,LOCATION_MZONE,0,nil,c,tp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
	local g=mg:FilterSelect(tp,s.altcheck,1,1,nil,lv,tp)
	if #g>0 then
		g:KeepAlive()
		e:SetLabelObject(g)
		return true
	end
	return false
end

function s.altop(e,tp,eg,ep,ev,re,r,rp,c,og,lmat,min,max)
	local g=e:GetLabelObject()
	local tc=g:GetFirst()
	local lv=c:GetLevel()
	local diff=lv-tc:GetLevel()
	
	Duel.RemoveCounter(tp,1,0,s.COUNTER_DARKLING,diff,REASON_COST)
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
	g:DeleteGroup()
end

function s.thcon1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

function s.thcon2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_SYNCHRO) and c:IsPreviousLocation(LOCATION_MZONE)
end

function s.thfilter(c)
	return s.Darkling(c) and c:IsAbleToHand()
end

function s.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(s.thfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,400)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_DECK)
end

function s.thop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.Damage(tp,400,REASON_EFFECT)>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local g=Duel.SelectMatchingCard(tp,s.thfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end

function s.spcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp 
end

function s.nyx_filter(c)
	return c:IsFaceup() and c:IsCode(s.NYX_CODE) and c:IsCanAddCounter(s.COUNTER_DARKLING,1)
end

function s.sptg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_PZONE) and chkc:IsControler(tp) and s.nyx_filter(chkc) end
	local c=e:GetHandler()
	if chk==0 then 
		return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		   and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
		   and Duel.IsExistingTarget(s.nyx_filter,tp,LOCATION_PZONE,0,1,nil)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,s.nyx_filter,tp,LOCATION_PZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,c,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,0,tp,LOCATION_EXTRA)
end

function s.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if c:IsRelateToEffect(e) and Duel.SpecialSummon(c,0,tp,tp,false,false,POS_FACEUP)>0 then
		if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() and tc:IsCanAddCounter(s.COUNTER_DARKLING,1) then
			tc:AddCounter(s.COUNTER_DARKLING,1)
			local sg=Duel.GetMatchingGroup(Card.IsSynchroSummonable,tp,LOCATION_EXTRA,0,nil,nil)
			if #sg>0 and Duel.SelectYesNo(tp,aux.Stringid(id,3)) then
				Duel.BreakEffect()
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local pg=sg:Select(tp,1,1,nil)
				if #pg>0 then
					Duel.SynchroSummon(tp,pg:GetFirst(),nil)
				end
			end
		end
	end
end
