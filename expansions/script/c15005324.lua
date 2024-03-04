local m=15005324
local cm=_G["c"..m]
cm.name="忆域迷因-『何物朝向死亡』"
function cm.initial_effect(c)
	c:EnableCounterPermit(0xf34)
	c:SetCounterLimit(0xf34,3)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2)
	c:EnableReviveLimit()
	--Being Mortal
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.executetg)
	e1:SetOperation(cm.executeop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(cm.executecon)
	c:RegisterEffect(e2)
	--Nightfall
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetType(EFFECT_TYPE_QUICK_F)
	e3:SetCode(EVENT_CHAINING)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(cm.nightfallcon)
	e3:SetCost(cm.nightfallcost)
	e3:SetTarget(cm.nightfalltg)
	e3:SetOperation(cm.nightfallop)
	c:RegisterEffect(e3)
	--
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EFFECT_DESTROY_REPLACE)
	e4:SetTarget(cm.reptg)
	e4:SetOperation(cm.repop)
	c:RegisterEffect(e4)
	--spsummon
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,3))
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetTarget(cm.sptg)
	e5:SetOperation(cm.spop)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e6:SetCode(EVENT_LEAVE_FIELD_P)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetLabelObject(e5)
	e6:SetOperation(cm.chk)
	c:RegisterEffect(e6)
end
function cm.executetg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ovg=c:GetOverlayGroup()
	if chk==0 then return #ovg>0 end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,ovg,#ovg,0,0)
end
function cm.executeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ovg=c:GetOverlayGroup()
	if #ovg>0 and c:IsRelateToEffect(e) then
		Duel.SendtoDeck(ovg,nil,2,REASON_EFFECT)
		local ct=ovg:FilterCount(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)+1
		if ct==0 then return end
		c:AddCounter(0xf34,ct,true)
	end
end
function cm.executecon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.nightfallcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_BATTLE_DESTROYED) and re:GetHandler()~=e:GetHandler()
		and re:IsActiveType(TYPE_MONSTER)
end
function cm.nightfallcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanRemoveCounter(tp,0xf34,1,REASON_COST) end
	c:RemoveCounter(tp,0xf34,1,REASON_COST)
end
function cm.nightfalltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if chk==0 then return rc:IsRelateToEffect(re) and (rc:IsLocation(LOCATION_ONFIELD) or rc:IsLocation(LOCATION_GRAVE)) end
end
function cm.nightfallop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local rc=re:GetHandler()
	if c:IsRelateToEffect(e)
		and rc:IsRelateToEffect(re) and not rc:IsImmuneToEffect(e) then
		local og=rc:GetOverlayGroup()
		if og:GetCount()>0 then
			Duel.SendtoGrave(og,REASON_RULE)
		end
		Duel.Overlay(c,rc)
	end
end
function cm.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsReason(REASON_BATTLE+REASON_EFFECT) and not c:IsReason(REASON_REPLACE)
		and c:IsCanRemoveCounter(tp,0xf34,1,REASON_EFFECT) end
	return true
end
function cm.repop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RemoveCounter(tp,0xf34,1,REASON_EFFECT)
end
function cm.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ovg=e:GetLabelObject()
	if chk==0 then return #ovg>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,#ovg,PLAYER_ALL,LOCATION_GRAVE)
end
function cm.spfilter(c,e,tp)
	return (c:IsCanBeSpecialSummoned(e,0,tp,false,false) or c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp))
end
function cm.spfilter1(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false) and c:GetOwner()==tp
end
function cm.spfilter2(c,e,tp)
	return c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP,1-tp) and c:GetOwner()==1-tp
end
function cm.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ovg=e:GetLabelObject()
	local rg=ovg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local ft2=Duel.GetLocationCount(1-tp,LOCATION_MZONE,tp)
	if (ft1<=0 and ft2<=0) or rg:GetCount()<=0 then return end
	local sg=nil
	local sg1=rg:Filter(cm.spfilter1,nil,e,tp)
	local sg2=rg:Filter(cm.spfilter2,nil,e,tp)
	local gc1=sg1:GetCount()
	local gc2=sg2:GetCount()
	if Duel.IsPlayerAffectedByEffect(tp,59822133) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		if ft1<=0 and gc2>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg2:Select(tp,1,1,nil)
		elseif ft2<=0 and gc1>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=sg1:Select(tp,1,1,nil)
		elseif (gc1>0 and ft1>0) or (gc2>0 and ft2>0) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg=rg:FilterSelect(tp,cm.spfilter,1,1,nil,e,tp)
		end
		if sg~=nil then
			Duel.SpecialSummon(sg,0,tp,sg:GetFirst():GetOwner(),false,false,POS_FACEUP)
		end
		rg:Clear()
		return
	end
	if gc1>0 and ft1>0 then
		if sg1:GetCount()>ft1 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg1=sg1:Select(tp,ft1,ft1,nil)
		end
		local sc=sg1:GetFirst()
		while sc do
			Duel.SpecialSummonStep(sc,0,tp,tp,false,false,POS_FACEUP)
			sc=sg1:GetNext()
		end
	end
	if gc2>0 and ft2>0 then
		if sg2:GetCount()>ft2 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			sg2=sg2:Select(tp,ft2,ft2,nil)
		end
		local sc=sg2:GetFirst()
		while sc do
			Duel.SpecialSummonStep(sc,0,tp,1-tp,false,false,POS_FACEUP)
			sc=sg2:GetNext()
		end
	end
	Duel.SpecialSummonComplete()
	rg:Clear()
end
function cm.chk(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ovg=c:GetOverlayGroup()
	ovg:KeepAlive()
	e:GetLabelObject():SetLabelObject(ovg)
end