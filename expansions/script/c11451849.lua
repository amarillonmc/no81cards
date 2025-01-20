--孤注一抽
local cm,m=GetID()
function cm.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(cm.activate)
	c:RegisterEffect(e1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetCondition(cm.discon)
	e1:SetOperation(cm.disop)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	return rp==tp
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local ac=false
	if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)>0 and Duel.SelectYesNo(1-tp,aux.Stringid(m,0)) then
		ac=true
	end
	local bc=false
	if e:GetLabel()==0 and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		bc=true
		e:SetLabel(1)
	end
	if ac then
		Duel.DiscardHand(1-tp,nil,1,1,REASON_DISCARD+REASON_EFFECT,nil)
		Duel.NegateEffect(ev)
	elseif not ac and bc then
		local op0=re:GetOperation() or (function() end)
		local op2=function(e,tp,eg,ep,ev,re,r,rp)
					e:SetOperation(op0)
					op0(e,tp,eg,ep,ev,re,r,rp)
					local ct=6-Duel.GetFieldGroupCount(tp,LOCATION_HAND,0)
					if ct>0 then
						Duel.BreakEffect()
						Duel.Draw(tp,ct,REASON_EFFECT)
					end
				end
		re:SetOperation(op2)
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e1:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
		e1:SetCode(EVENT_CHAIN_SOLVED)
		e1:SetCountLimit(1)
		e1:SetLabel(ev)
		e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ev==e:GetLabel() end)
		e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) re:SetOperation(op0) end)
		e1:SetReset(RESET_CHAIN)
		Duel.RegisterEffect(e1,tp)
		local e2=e1:Clone()
		e2:SetCode(EVENT_CHAIN_NEGATED)
		Duel.RegisterEffect(e2,tp)
	end
end