--枢机神侍·霜冻之蓝
local cm,m,o=GetID()
function cm.initial_effect(c)
	--special summon
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_HAND)
	e1:SetCondition(cm.spcon)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetRange(LOCATION_GRAVE)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.spcon2)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1,EFFECT_COUNT_CODE_SINGLE)
	e3:SetCost(cm.cost)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCondition(cm.con)
	c:RegisterEffect(e4)
end
function cm.spcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,5,nil)
end
function cm.spcon2(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and Duel.IsPlayerAffectedByEffect(tp,60010084)
		and Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_HAND,0,5,nil)
end


function cm.con2filter(c)
	return c:IsSetCard(0xc622) and c:GetOriginalType()==TYPE_EQUIP and not c:IsDisabled()
end
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.sfil,tp,LOCATION_HAND,0,nil)
	local eg=e:GetHandler():GetEquipGroup()
	return #g==0 and Duel.IsPlayerAffectedByEffect(tp,60010091) and eg:IsExists(cm.con2filter,1,nil)
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
	local g=Duel.SelectMatchingCard(tp,aux.TRUE,tp,LOCATION_HAND,0,1,2,nil)
	Duel.SendtoGrave(g,REASON_COST+REASON_DISCARD)
	e:SetLabel(#Duel.GetOperatedGroup())
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) and Duel.IsPlayerCanDraw(1-tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,PLAYER_ALL,1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,PLAYER_ALL,1)
end

function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local num=e:GetLabel()*2
	Duel.Draw(tp,num,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	Duel.Draw(1-tp,num,REASON_EFFECT)
	g:Merge(Duel.GetOperatedGroup())
	Duel.SendtoGrave(g:Filter(cm.tgfil,nil),REASON_EFFECT)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(cm.con2)
	e1:SetTarget(cm.tg2)
	e1:SetOperation(cm.op2)
	e1:SetCountLimit(1)
	e1:SetReset(RESET_PHASE+PHASE_END)
	Duel.RegisterEffect(e1,tp)
end
function cm.tgfil(c)
	return not c:IsSetCard(0xc622)
end

function cm.con2(e, tp, eg, ep, ev, re, r, rp)
	local ch = Duel.GetCurrentChain() - 1
	if ch <= 0 then return false end
	local cplayer = Duel.GetChainInfo(ch, CHAININFO_TRIGGERING_CONTROLER)
	local ceff = Duel.GetChainInfo(ch, CHAININFO_TRIGGERING_EFFECT)
	if re:GetHandler():IsDisabled() or not Duel.IsChainDisablable(ev) then return false end
	return ep == 1 - tp and cplayer == tp and (ceff:GetHandler():IsSetCard(0xfefd) or ceff:GetHandler():IsSetCard(0xfd))
end

function cm.tg2(e, tp, eg, ep, ev, re, r, rp, chk)
	if chk == 0 then return true end
	Duel.SetOperationInfo(0, CATEGORY_NEGATE, eg, 1, 0, 0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0, CATEGORY_DESTROY, eg, 1, 0, 0)
	end
end

function cm.op2(e, tp, eg, ep, ev, re, r, rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) then
		Duel.Destroy(eg, REASON_EFFECT)
	end
end





