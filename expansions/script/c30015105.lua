--终墟解脱
local m=30015105
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)  
	e1:SetHintTiming(TIMING_DAMAGE_STEP,TIMING_DAMAGE_STEP+TIMINGS_CHECK_MONSTER)
	e1:SetProperty(EFFECT_FLAG_DAMAGE_STEP)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	--e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_OATH)
	e1:SetTarget(cm.target)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=ors.redraw(c)
	--all
	local ge1=ors.alldrawflag(c)
end
c30015105.isoveruins=true
c30015105[0]=0
c30015105[1]=0
--all
--Effect 1
function cm.nsf(c)
	local b1=c:IsSummonType(SUMMON_TYPE_NORMAL)
	local b2=c:IsSummonType(SUMMON_TYPE_ADVANCE)
	local b3=c:IsSummonType(SUMMON_TYPE_FLIP)
	local b4=c:IsSummonType(SUMMON_TYPE_DUAL)
	return c:IsFaceup() and (b1 or b2 or b3 or b4)
end
function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local p1=e:GetHandlerPlayer()
	if Duel.GetTurnPlayer()==p1 then
		if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,nil)
			and Duel.IsExistingMatchingCard(cm.nsf,tp,LOCATION_MZONE,0,1,nil) end
		e:SetCategory(CATEGORY_TOGRAVE+CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
		local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,nil)
		Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,1,0,0)
	else
		if chk==0 then return true end
		e:SetCategory(CATEGORY_REMOVE+CATEGORY_GRAVE_ACTION)
	end
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local p1=e:GetHandlerPlayer()
	if Duel.GetTurnPlayer()==p1 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,Card.IsAbleToGrave,tp,0,LOCATION_ONFIELD,1,1,nil)
		if #g>0 then
			if Duel.SendtoGrave(g,REASON_EFFECT)>0
				and Duel.IsExistingMatchingCard(cm.nsf,tp,LOCATION_MZONE,0,1,nil) then
				local tag=Duel.GetMatchingGroup(cm.nsf,tp,LOCATION_MZONE,0,nil)
				for tc in aux.Next(tag) do  
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_UPDATE_ATTACK)
					e1:SetValue(500)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			end
		end
	else
		local e01=Effect.CreateEffect(e:GetHandler())
		e01:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e01:SetCode(EVENT_CHAINING)
		e01:SetOperation(cm.chainop)
		e01:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e01,tp)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD)
		e1:SetCode(EFFECT_CHANGE_DAMAGE)
		e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
		e1:SetTargetRange(1,0)
		e1:SetValue(cm.val)
		e1:SetReset(RESET_PHASE+PHASE_END,2)
		Duel.RegisterEffect(e1,tp)
	end
	local res=1
	Duel.BreakEffect()
	ors.exrmop(e,tp,res)
end
function cm.val(e,re,dam,r,rp,rc)
	local tp=e:GetOwnerPlayer()
	local ct=daval[0]+daval[1]
	local dct
	if ct*100>=1500 then 
		dct=1500 
	else 
		dct=ct*100 
	end 
	local dval
	if dct>=dam then 
		dval=0 
	else 
		dval=dam-dct 
	end
	return dval
end

function cm.chainop(e,tp,eg,ep,ev,re,r,rp)
	local rc=re:GetHandler()
	if ors.stf(rc) and ep==tp then
		Duel.SetChainLimit(cm.chainlm)
	end
end
function cm.chainlm(e,ep,tp)
	return tp==ep
end 