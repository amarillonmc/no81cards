--归墟仲裁·聚引
local m=30015025
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--summonproc or overuins
	local e0=ors.summonproc(c,9,4,2)
	--Effect 1
	local e1=ors.atkordef(c,100,2500)
	--Effect 2 
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,0))
	e51:SetType(EFFECT_TYPE_QUICK_O)
	e51:SetCode(EVENT_FREE_CHAIN)
	e51:SetRange(LOCATION_MZONE)
	e51:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e51:SetCountLimit(1)
	e51:SetCondition(ors.adsumcon)
	e51:SetTarget(cm.settg)
	e51:SetOperation(cm.setop)
	c:RegisterEffect(e51) 
	--Effect 3 
	local e7=ors.monsterle(c)
	--all
	local e9=ors.alldrawflag(c)
end
c30015025.isoveruins=true
--Effect 2 
function cm.setf(c)
	return ors.setf(c,tp) and ors.stf(c) 
end
function cm.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.setf,tp,LOCATION_DECK,0,1,nil,tp) end
end
function cm.setop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=Duel.SelectMatchingCard(tp,cm.setf,tp,LOCATION_DECK,0,1,1,nil)
	if #g==0 then return end
	local tc=g:GetFirst()
	if Duel.SSet(tp,tc)>0 then
			local b1=tc:IsType(TYPE_QUICKPLAY) or tc:IsType(TYPE_TRAP)
			if b1 then
				if tc:IsType(TYPE_QUICKPLAY) then
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				else
					local e1=Effect.CreateEffect(e:GetHandler())
					e1:SetType(EFFECT_TYPE_SINGLE)
					e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
					e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
					e1:SetReset(RESET_EVENT+RESETS_STANDARD)
					tc:RegisterEffect(e1)
				end
			else
				local te=tc:GetActivateEffect()
				local se=te:Clone()
				local con_c=te:GetCondition()
				se:SetProperty(te:GetProperty(),EFFECT_FLAG2_COF)
				se:SetCode(EVENT_CHAIN_END)
				se:SetCondition(function(e,tp,eg,ep,ev,re,r,rp)
					if Duel.GetCurrentChain()~=0 or not e:GetHandler():IsLocation(LOCATION_SZONE) then return false end
					return not con_c or con_c(e,tp,eg,ep,ev,re,r,rp)
				end)
				se:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END)
				tc:RegisterEffect(se)
			end
	end
end 
