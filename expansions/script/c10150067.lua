--大怪兽大对波
function c10150067.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0+TIMING_DRAW_PHASE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetTarget(c10150067.target)
	e1:SetOperation(c10150067.activate)
	c:RegisterEffect(e1)  
	--control
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10150067,0))
	e2:SetCategory(CATEGORY_CONTROL)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetRange(LOCATION_GRAVE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetHintTiming(0,0x1e0)
	e2:SetCost(aux.bfgcost)
	e2:SetCondition(aux.exccon)
	e2:SetTarget(c10150067.ctg)
	e2:SetOperation(c10150067.cop)
	c:RegisterEffect(e2)  
end
function c10150067.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0x10) and c:IsAbleToChangeControler()
end
function c10150067.cfilter(c)
	return c:IsAbleToChangeControler()
end
function c10150067.filter1(c)
	return c:IsFaceup() and c:IsSetCard(0xd3) and c:IsAbleToChangeControler()
end
function c10150067.ctg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10150067.cfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c10150067.cfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g1=Duel.SelectTarget(tp,c10150067.cfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g2=Duel.SelectTarget(tp,c10150067.cfilter,tp,0,LOCATION_MZONE,1,1,nil)
	g1:Merge(g2)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g1,2,0,0)
end
function c10150067.cop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS)
	local a=g:GetFirst()
	local b=g:GetNext()
	if a:IsRelateToEffect(e) and b:IsRelateToEffect(e) then
		Duel.SwapControl(a,b)
	end
end
function c10150067.filter(c)
	return c:IsSetCard(0xd3) and c:IsFaceup()
end
function c10150067.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(c10150067.filter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingTarget(c10150067.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SELF)
	local g1=Duel.SelectTarget(tp,c10150067.filter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_OPPO)
	local g2=Duel.SelectTarget(tp,c10150067.filter,tp,0,LOCATION_MZONE,1,1,nil)
end
function c10150067.ffilter(c,e)
	return c:IsFaceup() and c:IsRelateToEffect(e)
end
function c10150067.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(c10150067.ffilter,nil,e)
	local dg=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,g)
	if dg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(10150067,0)) then
	   Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(10150067,1))
	   Duel.Destroy(dg,REASON_EFFECT)
	end
	if g:GetCount()<2 then return end
	local tc1=g:GetFirst()
	local tc2=g:GetNext()
	tc1:SetCardTarget(tc2)
	local fid=e:GetHandler():GetFieldID()
	tc1:RegisterFlagEffect(10150067,RESET_EVENT+0x5fe0000,0,1,fid)
	tc2:RegisterFlagEffect(10150067,RESET_EVENT+0x5fe0000,0,1,fid)
	--act limit
	local e1=Effect.CreateEffect(tc1)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,1)
	e1:SetReset(RESET_EVENT+0x1fe0000)
	e1:SetLabel(fid)
	e1:SetCondition(c10150067.con)
	e1:SetValue(c10150067.aclimit)
	tc2:RegisterEffect(e1,true)
	--cannot attack
	local e2=Effect.CreateEffect(tc1)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EFFECT_CANNOT_ATTACK)
	e2:SetReset(RESET_EVENT+0x1fe0000)
	e2:SetLabel(fid)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetCondition(c10150067.con)
	e2:SetTarget(c10150067.antarget)
	tc2:RegisterEffect(e2,true)
end
function c10150067.fffilter(c,fid)
	return c:GetFlagEffectLabel(10150067)==fid
end
function c10150067.con(e)
	local g=Group.FromCards(e:GetHandler(),e:GetOwner())
	return g:FilterCount(c10150067.fffilter,nil,e:GetLabel())==2 
end
function c10150067.aclimit(e,re,tp)
	local rc=re:GetHandler()
	return rc:IsLocation(LOCATION_MZONE) and not rc:IsImmuneToEffect(e) and rc~=e:GetHandler() and rc~=e:GetOwner()
end
function c10150067.antarget(e,c)
	return c~=e:GetHandler() and c~=e:GetOwner()
end
