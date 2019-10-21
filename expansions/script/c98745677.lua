local cid=c98745677
local id=98745677
function cid.initial_effect(c)
	c:EnableCounterPermit(0x57b)
	--Synchro Summon (X)
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--Equip "Resonator" monster, Gain Counters (1)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_EQUIP)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(cid.eqcon)
	e1:SetTarget(cid.eqtg)
	e1:SetOperation(cid.eqop)
	c:RegisterEffect(e1)
	--Remove Counters, Special Summon "Resonator" monsters (2)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,0))
	e2:SetCategory(CATEGORY_COUNTER)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1,id)
	e2:SetCost(cid.sscost)
	e2:SetTarget(cid.sstg)
	e2:SetOperation(cid.ssop)
	c:RegisterEffect(e2)
end

--Filters
function cid.filter(c,e,tp)
	return c:IsSetCard(0x57) and c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end

function cid.eqlimit(e,c)
	return c==e:GetLabelObject()
end

function cid.eqfilter(c,tp,mc)
	return c:IsSetCard(0x57) and c:IsType(TYPE_MONSTER) and c:CheckUniqueOnField(tp) and not c:IsForbidden() --and mc:IsCanAddCounter(0x57b,c:GetLevel())
end

function cid.eqcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_SYNCHRO)
end

--Equip "Resonator" monster, Gain Counters (1)
function cid.eqtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(cid.eqfilter,tp,LOCATION_DECK,0,1,nil,e:GetHandler()) end
	Duel.SetOperationInfo(0,CATEGORY_EQUIP,nil,1,tp,LOCATION_DECK)
end

function cid.eqop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if Duel.GetLocationCount(tp,LOCATION_SZONE)>0 and c:IsFaceup() and c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_EQUIP)
	if c:IsFacedown() or not c:IsRelateToEffect(e) then return end
	local g=Duel.SelectMatchingCard(tp,cid.eqfilter,tp,LOCATION_DECK,0,1,1,nil,tp,c)
	local tc=g:GetFirst()
	if tc then
		if not Duel.Equip(tp,tc,c,true) then return end
		local lk=tc:GetLevel()
		if lk>0 then
			c:AddCounter(0x57b,lk)
		end
			--Duel.Equip(tp,g:GetFirst(),c)
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_EQUIP_LIMIT)
			e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			e1:SetValue(cid.eqlimit)
			e1:SetLabelObject(c)
			g:GetFirst():RegisterEffect(e1)
		end
	end
end

--Remove Counters, Special Summon "Resonator" monsters (2)
function cid.sscost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsCanRemoveCounter(tp,0x53,ct,REASON_COST) end
	local ct=e:GetHandler():GetCounter(0x57b)
	e:SetLabel(ct)
	e:GetHandler():RemoveCounter(tp,0x57b,ct,REASON_COST)
end

function cid.sstg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and cid.filter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(cid.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,1,e,tp) end
	local val=e:GetLabel()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cid.filter,tp,LOCATION_GRAVE,LOCATION_GRAVE,val,val,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end

function cid.ssop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tg=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local rg=tg:Filter(Card.IsRelateToEffect,nil,e)
	if rg:GetCount()>0 then
	local ex=Effect.CreateEffect(c)
		ex:SetType(EFFECT_TYPE_SINGLE)
		ex:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		ex:SetCode(EFFECT_CANNOT_BE_LINK_MATERIAL)
		ex:SetValue(1)
		c:RegisterEffect(ex)
		Duel.SpecialSummon(tg,0,tp,tp,nil,nil,POS_FACEUP)
	end
end