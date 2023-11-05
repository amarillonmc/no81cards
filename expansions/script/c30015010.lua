--归墟仲裁·清无
local m=30015010
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--not Special Summon
	local ea=ors.notsp(c)
	--summonproc or overuins
	local e0=ors.summonproc(c,11,5,3)
	--Effect 1
	local e1=ors.atkordef(c,500,5000)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e7)
	--Effect 2 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE) 
	e3:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e3:SetTarget(cm.rmtg)
	e3:SetOperation(cm.rmop)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_REMOVE)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE) 
	e4:SetCondition(cm.rmcon)
	e4:SetTarget(cm.rmtg)
	e4:SetOperation(cm.rmop)
	c:RegisterEffect(e4)	
	--Effect 3 
	local e20=Effect.CreateEffect(c)
	e20:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e20:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e20:SetCode(EVENT_LEAVE_FIELD_P)
	e20:SetOperation(ors.lechk)
	c:RegisterEffect(e20)
	local e21=Effect.CreateEffect(c)
	e21:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	e21:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e21:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_CANNOT_INACTIVATE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	e21:SetCode(EVENT_LEAVE_FIELD)
	e21:SetLabelObject(e20)
	e21:SetCondition(cm.orscon)
	e21:SetTarget(cm.orstg)
	e21:SetOperation(cm.orsop)
	c:RegisterEffect(e21)
	--all
	local ge1=ors.allop2(c)
end
c30015010.isoveruins=true
--all
--Effect 2 
function cm.rmcon(e)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.kf(c,tp)
	local b1=c:IsType(TYPE_SPELL+TYPE_TRAP)
	local b2=not c:IsAbleToRemove(tp,POS_FACEDOWN)
	return b1 and b2
end
function cm.rmf(c,tp)
	local b1=c:IsType(TYPE_SPELL+TYPE_TRAP)
	local b2=c:IsAbleToRemove(tp,POS_FACEDOWN)
	return b1 and b2
end
function cm.rmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	local rg=g:Filter(cm.rmf,nil,tp)
	if chk==0 then
		return #rg>0 and g:FilterCount(cm.kf,nil,tp)==0
	end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,rg,#rg,0,0)
	Duel.SetChainLimit(cm.chlimit)
end
function cm.chlimit(e,ep,tp)
	return tp==ep
end
function cm.rmop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsType,tp,0,LOCATION_GRAVE+LOCATION_ONFIELD,nil,TYPE_SPELL+TYPE_TRAP)
	local rg=g:Filter(cm.rmf,nil,tp)
	if #rg==0 then return false end
	Duel.Remove(rg,POS_FACEDOWN,REASON_EFFECT)
end
--Effect 3 
function cm.ff(c,tp,code) 
	return c:IsAbleToRemove(tp,POS_FACEDOWN) and c:IsCode(code)
end  
function cm.orscon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousLocation(LOCATION_ONFIELD)
end
function cm.orstg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if chk==0 then return true end
	local sg=Group.FromCards(c)
	if ct>0 then
		local rc=c:GetReasonCard()
		local re=c:GetReasonEffect()
		if not rc and re then
			local sc=re:GetHandler()
			if not rc then
				Duel.SetTargetCard(sc)
				sg:AddCard(sc)
			end
		end 
		if rc then 
			Duel.SetTargetCard(rc)
			sg:AddCard(rc)
		end
	end
	if ct>0 then
		loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA 
		local xg=sg:Clone()
		xg:RemoveCard(c)
		local rmg=Duel.GetMatchingGroup(cm.ff,tp,0,loc,nil,tp,xg:GetFirst():GetCode())
		rmg:AddCard(c)
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,rmg,#rmg,0,0)
	else
		Duel.SetOperationInfo(0,CATEGORY_REMOVE,sg,#sg,0,0)
	end
end
function cm.orsop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ct=e:GetLabelObject():GetLabel() 
	if c:IsRelateToEffect(e) then
		Duel.Remove(c,POS_FACEDOWN,REASON_EFFECT)
	end
	if ct==1 then
		local sc=Duel.GetFirstTarget() 
		if sc==nil then return false end
		local code=sc:GetCode()
		loc=LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE+LOCATION_DECK+LOCATION_EXTRA 
		local rmg=Duel.GetMatchingGroup(cm.ff,tp,0,loc,nil,tp,code)
		if #rmg==0 then return false end
		local chka=0
		local chkb=0
		local chkc=0
		if rmg:FilterCount(Card.IsLocation,nil,LOCATION_HAND)>0 then
			chka=1
		end
		if rmg:FilterCount(Card.IsLocation,nil,LOCATION_DECK)>0 then
			chkb=1
		end
		if rmg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)>0 then
			chkc=1
		end
		Duel.Hint(HINT_CARD,0,m) 
		Duel.BreakEffect()
		Duel.ConfirmCards(tp,rmg)
		if Duel.Remove(rmg,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
		if chka>0 then Duel.ShuffleHand(1-tp) end
		if chkb>0 then Duel.ShuffleDeck(1-tp) end
		if chkc>0 then Duel.ShuffleExtra(1-tp) end
	end
end