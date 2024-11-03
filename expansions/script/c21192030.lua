--幻想时间 含苞待绽
local m=21192030
local cm=_G["c"..m]
local setcard=0x3917
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1164)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.syscon(cm.x,aux.NonTuner(cm.x),1,9))
	e0:SetTarget(cm.systg(cm.x,aux.NonTuner(cm.x),1,9))
	e0:SetOperation(aux.SynOperation(cm.x,aux.NonTuner(cm.x),1,9))
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0) 
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_GRAVE_SPSUMMON)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMING_MAIN_END+TIMING_END_PHASE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,m)
	e1:SetCost(cm.cost)
	e1:SetTarget(cm.tg)
	e1:SetOperation(cm.op)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_GRAVE_ACTION+CATEGORY_TODECK+CATEGORY_RECOVER)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetCountLimit(1,m+1)
	e2:SetCondition(cm.con2)
	e2:SetTarget(cm.tg2)
	e2:SetOperation(cm.op2)
	c:RegisterEffect(e2)
end
function cm.x(c)
	return c:IsSetCard(setcard)
end
function cm.q(c,sc)
	return c:IsCanBeSynchroMaterial(sc) and c:IsFaceup() and c:IsSetCard(setcard)
end
function cm.syscon(f1,f2,minc,maxc)
	return  function(e,c,smat,mg,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end 
				if mg==nil then 
					mg=Duel.GetMatchingGroup(cm.q,c:GetControler(),12,0,nil,c) 
				end 
				if smat and smat:IsTuner(c) and (not f1 or f1(smat)) then
					return Duel.CheckTunerMaterial(c,smat,f1,f2,minc,maxc,mg) end
				return Duel.CheckSynchroMaterial(c,f1,f2,minc,maxc,smat,mg)
			end
end
function cm.systg(f1,f2,minc,maxc)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,smat,mg,min,max)
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				if mg==nil then 
					mg=Duel.GetMatchingGroup(cm.q,c:GetControler(),12,0,nil,c) 
				end 
				local g=nil 
				if smat and smat:IsTuner(c) and (not f1 or f1(smat)) then
					g=Duel.SelectTunerMaterial(c:GetControler(),c,smat,f1,f2,minc,maxc,mg)
				else
					g=Duel.SelectSynchroMaterial(c:GetControler(),c,f1,f2,minc,maxc,smat,mg)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.w(c)
	return c:IsFaceup() and c:IsAbleToRemoveAsCost() and c:IsSetCard(setcard) and c:GetOriginalType()&TYPE_MONSTER~=0 and Duel.GetMZoneCount(c:GetControler(),c)>0
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.w,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,cm.w,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function cm.e(c,e,tp)
	return c:IsSetCard(setcard) and not c:IsCode(m) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEUP_DEFENSE)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.e,tp,0x30,0,1,nil,e,tp) end
	Duel.Hint(3,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,cm.e,tp,0x30,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
	Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP_DEFENSE)
	end
end
function cm.con2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==1-tp
end
function cm.r(c)
	return c:IsSetCard(setcard) and c:IsAbleToDeck() and c:IsFaceupEx()
end
function cm.tg2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingTarget(cm.r,tp,0x30,0,1,nil) end
	Duel.Hint(3,tp,HINTMSG_TODECK)
	local g=Duel.SelectTarget(tp,cm.r,tp,0x30,0,1,3,nil)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,g,#g,tp,0x30)
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,#g*800)
end
function cm.t(c)
	return c:IsSetCard(setcard) and c:IsType(6) and c:IsSSetable()
end
function cm.op2(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	if #g>0 and Duel.SendtoDeck(g,nil,2,REASON_EFFECT)>0 and g:IsExists(Card.IsLocation,1,nil,LOCATION_DECK+LOCATION_EXTRA) then
	local og=g:Filter(Card.IsLocation,nil,LOCATION_DECK+LOCATION_EXTRA)
		if Duel.Recover(tp,#og*800,REASON_EFFECT)>0 and Duel.IsExistingMatchingCard(Card.IsAbleToGrave,tp,LOCATION_HAND,0,1,e:GetHandler()) and Duel.IsExistingMatchingCard(cm.t,tp,1,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		if Duel.DiscardHand(tp,Card.IsAbleToGrave,1,1,REASON_EFFECT)<1 then return end	
		Duel.Hint(3,tp,HINTMSG_SET)
		local tc=Duel.SelectMatchingCard(tp,cm.t,tp,1,0,1,1,nil):GetFirst()
		Duel.SSet(tp,tc)
		end
	end
end