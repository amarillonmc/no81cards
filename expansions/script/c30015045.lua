--归墟戮杀波
local m=30015045
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--Effect 1
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_REMOVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(cm.xtg)
	e1:SetOperation(cm.xop)
	c:RegisterEffect(e1)
	--Effect 2  
	local e2=ors.redraw(c)
	--all
	local ge1=ors.allop2(c)
end
c30015045.isoveruins=true
--all
--Effect 1
function cm.xcon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetFieldGroupCount(1-tp,LOCATION_MZONE,0)
	local b=Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)
	local c=Duel.GetFieldGroupCount(1-tp,LOCATION_ONFIELD,0)
	local d=Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
	return a-b>=2 or c-d>=5
end
function cm.xtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local mg=Duel.GetMatchingGroup(Card.IsFacedown,tp,LOCATION_REMOVED,LOCATION_REMOVED,nil)
	if chk==0 then return true end
	if #mg>0 and e:IsHasType(EFFECT_TYPE_ACTIVATE) then
		Duel.SetChainLimit(aux.FALSE)
	end
end
function cm.xop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_DISEFFECT)
	e1:SetValue(cm.effectfilter)
	e1:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e1,tp)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_CANNOT_INACTIVATE)
	e2:SetValue(cm.effectfilter)
	e2:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e2,tp)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_LEAVE_FIELD)
	e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e3:SetCondition(cm.refvengecon)
	e3:SetOperation(cm.refvengeop)
	e3:SetReset(RESET_PHASE+PHASE_END,2)
	Duel.RegisterEffect(e3,tp)
	local res=1
	Duel.BreakEffect()
	ors.exrmop(e,tp,res)
end
function cm.effectfilter(e,ct)
	local te=Duel.GetChainInfo(ct,CHAININFO_TRIGGERING_EFFECT)
	local tc=te:GetHandler()
	return te:IsActiveType(TYPE_TRAP) or ors.stf(tc) 
end
function cm.ref(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD)  
		and (c:GetPreviousTypeOnField()&TYPE_SPELL~=0 or c:GetPreviousTypeOnField()&TYPE_TRAP~=0)
		and c:GetReasonPlayer()==1-tp
end
function cm.refvengecon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(cm.ref,1,nil,tp) 
end
function cm.refvengeop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler(c)
	local xg=eg:Filter(cm.ref,nil,tp)
	for tc in aux.Next(xg) do  
		local sg=Group.CreateGroup()
		local rc=tc:GetReasonCard()
		local re=tc:GetReasonEffect()
		if not rc and re then
			local sc=re:GetHandler()
			if not rc then
				sg:AddCard(sc)
			end
		end 
		if rc then 
			sg:AddCard(rc)
		end 
		if #sg>0 then
			local bc=sg:GetFirst()
			local b1=bc:IsLocation(LOCATION_HAND+LOCATION_ONFIELD+LOCATION_GRAVE)
			local b2=bc:GetControler()==1-tp
			local b3=bc:IsAbleToRemove(tp,POS_FACEDOWN)
			local b4=not bc:IsType(TYPE_TOKEN)
			if b1 and  b2 and b3 and b4  then
				Duel.Hint(HINT_CARD,0,m)  
				Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(m,1))
				Duel.Remove(bc,POS_FACEDOWN,REASON_EFFECT)
			end
		end
	end
end 