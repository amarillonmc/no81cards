--星宫六喰 月兔
local m=33400602
local cm=_G["c"..m]
function cm.initial_effect(c)
	 --remove 
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_REMOVED)
	e2:SetProperty(EFFECT_FLAG_NO_TURN_RESET)
	e2:SetCountLimit(1,m)
	e2:SetCondition(cm.tdcon1)
	e2:SetTarget(cm.tdtg)
	e2:SetOperation(cm.tdop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetCondition(cm.tdcon2)
	c:RegisterEffect(e3)
 --xyz
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_DELAY)
	e4:SetCountLimit(1,m)
	e4:SetCondition(cm.con1)
	e4:SetTarget(cm.xyztg)
	e4:SetOperation(cm.xyzop)
	c:RegisterEffect(e4)
	local e41=Effect.CreateEffect(c)
	e41:SetDescription(aux.Stringid(m,1))
	e41:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e41:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e41:SetCode(EVENT_SPSUMMON_SUCCESS)
	e41:SetProperty(EFFECT_FLAG_DELAY)
	e41:SetCountLimit(1,m)
	e41:SetTarget(cm.xyztg)
	e41:SetOperation(cm.xyzop)
	c:RegisterEffect(e41)
--draw
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_DRAW)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_DELAY)
	e5:SetCountLimit(1,m+10000)
	e5:SetCondition(cm.con1)
	e5:SetTarget(cm.target)
	e5:SetOperation(cm.activate)
	c:RegisterEffect(e5)
	local e51=Effect.CreateEffect(c)
	e51:SetDescription(aux.Stringid(m,2))
	e51:SetCategory(CATEGORY_DRAW)
	e51:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e51:SetCode(EVENT_SPSUMMON_SUCCESS)
	e51:SetProperty(EFFECT_FLAG_DELAY)
	e51:SetCountLimit(1,m+10000)
	e51:SetTarget(cm.target)
	e51:SetOperation(cm.activate)
	c:RegisterEffect(e51)
end
function cm.tdcon1(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33460651)==0 
end
function cm.tdcon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,33460651)>0 
end
function cm.refilter(c,tp)
	return  c:IsSetCard(0x9342) and c:IsAbleToRemove()  and Duel.GetFlagEffect(tp,c:GetCode()+10000)==0
end
function cm.tdtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.refilter,tp,LOCATION_DECK,0,1,nil,tp) end   
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,tp,LOCATION_DECK)
end
function cm.tdop(e,tp,eg,ep,ev,re,r,rp)  
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE) 
		local g2=Duel.SelectMatchingCard(tp,cm.refilter,tp,LOCATION_DECK,0,1,1,nil,tp)
		local tc2=g2:GetFirst()
		Duel.Remove(tc2,POS_FACEUP,REASON_EFFECT)   
		Duel.RegisterFlagEffect(tp,tc2:GetCode()+10000,RESET_EVENT+RESET_PHASE+PHASE_END,0,0)		  
end

function cm.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return   (c:IsReason(REASON_COST) and re:IsHasType(0x7e0) and re:IsActiveType(TYPE_MONSTER)
		and c:IsPreviousLocation(LOCATION_OVERLAY) and re:GetHandler():IsSetCard(0x341) ) 
end
function cm.xyzfilter(c)
	return c:IsXyzSummonable(nil)
end
function cm.xyztg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.xyzfilter,tp,LOCATION_EXTRA,0,1,nil) and e:GetHandler():GetFlagEffect(m)==0 end
e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(cm.xyzfilter,tp,LOCATION_EXTRA,0,nil)
	if g:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=g:Select(tp,1,1,nil)
		Duel.XyzSummon(tp,tg:GetFirst(),nil)
	end
end

function cm.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1)  and e:GetHandler():GetFlagEffect(m)==0 end
e:GetHandler():RegisterFlagEffect(m,RESET_CHAIN,0,1)
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.activate(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	 Duel.Draw(p,d,REASON_EFFECT)   
end