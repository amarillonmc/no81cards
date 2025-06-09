--天の聖杯 Πνευμα(プネウマ)
function c260013011.initial_effect(c)
	c:EnableReviveLimit()
	c:SetSPSummonOnce(260013011)
	--special summon rule
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_CHAIN_SOLVING)
	e6:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e6:SetRange(LOCATION_EXTRA)
	e6:SetCondition(c260013011.chcon)
	e6:SetOperation(c260013011.chop)
	c:RegisterEffect(e6)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e7:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e7:SetRange(LOCATION_EXTRA)
	e7:SetCode(EVENT_BE_BATTLE_TARGET)
	e7:SetCondition(c260013011.atcon)
	e7:SetOperation(c260013011.atop)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e8:SetType(EFFECT_TYPE_FIELD)
	e8:SetCode(EFFECT_SPSUMMON_PROC)
	e8:SetRange(LOCATION_EXTRA)
	e8:SetCondition(c260013011.xyzcon)
	e8:SetOperation(c260013011.xyzop)
	e8:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e8)
	--spsummon condition
	local e9=Effect.CreateEffect(c)
	e9:SetType(EFFECT_TYPE_SINGLE)
	e9:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e9:SetCode(EFFECT_SPSUMMON_CONDITION)
	e9:SetValue(c260013011.splimit)
	c:RegisterEffect(e9)
	--act limit
	local e10=Effect.CreateEffect(c)
	e10:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e10:SetCode(EVENT_SPSUMMON)
	e10:SetOperation(c260013011.limop)
	c:RegisterEffect(e10)
	--【ここまでX召喚ルール】
	--immune
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_IMMUNE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(c260013011.efilter1)
	c:RegisterEffect(e1)
	
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(260013011,2))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(c260013011.descost)
	e2:SetTarget(c260013011.destg)
	e2:SetOperation(c260013011.desop)
	c:RegisterEffect(e2)
	
	--spsummon
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetTarget(c260013011.sptg2)
	e3:SetOperation(c260013011.spop2)
	c:RegisterEffect(e3)
end


--【召喚ルール】
function c260013011.cfilter(c,xyzc,tp)
	return c:IsControler(tp) and c:IsLocation(LOCATION_MZONE) and c:IsSetCard(0x943) and c:IsType(TYPE_LINK)
		and c:IsCanBeXyzMaterial(xyzc) and c:IsFaceup()
end
function c260013011.chcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	return g and g:IsExists(c260013011.cfilter,1,nil,c,tp) and Duel.IsChainNegatable(ev) and re:GetHandler():IsRelateToEffect(re)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c260013011.xyzfilter(c,e,tp,xyzc)
	return not c:IsType(TYPE_TOKEN) and (c:IsCanBeXyzMaterial(xyzc) or not c:IsType(TYPE_MONSTER))
end
function c260013011.xyzfilter2(c,e,tp)
	return not c:IsType(TYPE_TOKEN)
end
function c260013011.chop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	local g=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c260013011.xyzfilter,nil,e,tp,c)
	local g2=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS):Filter(c260013011.xyzfilter2,nil,e,tp)
	if Duel.GetFlagEffect(tp,260013011)==0 and g:GetCount()>0 and g:GetCount()==g2:GetCount() and rc:IsRelateToEffect(re)
		and Duel.IsChainNegatable(ev) and Duel.GetLocationCountFromEx(tp,tp,g,c)>0 and Duel.SelectYesNo(tp,aux.Stringid(260013011,0)) then
		Duel.ConfirmCards(1-tp,c)
		Duel.RegisterFlagEffect(tp,260013011,RESET_PHASE+PHASE_END,0,1)
		if Duel.NegateEffect(ev) then
			rc:CancelToGrave()
			g:AddCard(rc)
			local tc=g:GetFirst()
			while tc do
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				tc:RegisterFlagEffect(260013011,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				tc=g:GetNext()
			end
			Duel.XyzSummon(tp,c,nil)
		end
	end
end

function c260013011.atcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	return tc:IsControler(tp) and tc:IsFaceup() and tc:IsSetCard(0x943) and not tc:IsType(TYPE_TOKEN) and tc:IsType(TYPE_LINK)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false)
end
function c260013011.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if not (Duel.GetLocationCountFromEx(tp,tp,a,c)>0 or Duel.GetLocationCountFromEx(tp,tp,d,c)>0) then return end
	if not a:IsRelateToEffect(e) and a:IsAttackable() and not a:IsStatus(STATUS_ATTACK_CANCELED)
		and a:IsCanBeXyzMaterial(c) and d:IsCanBeXyzMaterial(c)
		and not d:IsRelateToEffect(e) and Duel.SelectYesNo(tp,aux.Stringid(260013011,0)) then
		Duel.ConfirmCards(1-tp,c)
		if Duel.NegateAttack() then
			local g=Group.FromCards(a,d)
			local tc=g:GetFirst()
			while tc do
				local og=tc:GetOverlayGroup()
				if og:GetCount()>0 then
					Duel.SendtoGrave(og,REASON_RULE)
				end
				tc:RegisterFlagEffect(260013011,RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END,0,1)
				tc=g:GetNext()
			end
			Duel.XyzSummon(tp,c,nil)
		end
	end
end

function c260013011.mfilter(c,xyzc)
	return c:GetFlagEffect(260013011)~=0 and (c:IsCanBeXyzMaterial(xyzc) or not c:IsType(TYPE_MONSTER))
end
function c260013011.xyzcon(e,c,og,min,max)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=nil
	if og then
		mg=og:Filter(c260013011.mfilter,nil,c)
	else
		mg=Duel.GetMatchingGroup(c260013011.mfilter,tp,0xff,0xff,nil,c)
	end
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and mg:GetCount()>0
end
function c260013011.xyzop(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
	local c=e:GetHandler()
	local g=nil
	local sg=Group.CreateGroup()
	local xyzg=Group.CreateGroup()
	if og then
		g=og
		local tc=og:GetFirst()
	else
		local mg=nil
		if og then
			mg=og:Filter(c260013011.mfilter,nil,c)
		else
			mg=Duel.GetMatchingGroup(c260013011.mfilter,tp,0xff,0xff,nil,c)
		end
		local ct=mg:GetCount()
		xyzg:Merge(mg)
	end
	c:SetMaterial(xyzg)
	Duel.Overlay(c,xyzg)
end

function c260013011.splimit(e,se,sp,st)
	return not e:GetHandler():IsLocation(LOCATION_EXTRA) or (bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ and se:GetHandler():IsCode(260013011))
end

function c260013011.limop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetCurrentChain()==0 then return end
	Duel.SetChainLimitTillChainEnd(c260013011.chlimit)
end
function c260013011.chlimit(e,rp,tp)
	return e:IsActiveType(TYPE_TRAP) and e:GetHandler():IsType(TYPE_COUNTER)
end


--【モンスター効果耐性】
function c260013011.efilter1(e,te)
	return te:GetOwnerPlayer()~=e:GetHandlerPlayer() and te:IsActiveType(TYPE_MONSTER)
end


--【破壊効果】
function c260013011.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_OATH)
	e1:SetCode(EFFECT_CANNOT_ATTACK)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	e:GetHandler():RegisterEffect(e1)
end
function c260013011.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,0,LOCATION_ONFIELD,1,nil) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
end
function c260013011.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,0,LOCATION_ONFIELD,nil)
	Duel.Destroy(g,REASON_EFFECT)
end


--【EXデッキ帰還】
function c260013011.spfilter(c,e,tp)
	return c:IsSetCard(0x943) and c:IsCanBeSpecialSummoned(e,0,tp,false,false) and not c:IsType(TYPE_XYZ)
	
end
function c260013011.sptg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,e:GetHandler(),1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_GRAVE)
end
function c260013011.spop2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) or c:IsFacedown() then return end
	Duel.SendtoDeck(c,nil,2,REASON_EFFECT)
	if c:IsLocation(LOCATION_EXTRA) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(c260013011.spfilter,tp,LOCATION_GRAVE,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(260013011,1)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,true,false,POS_FACEUP)
		end
	end
end