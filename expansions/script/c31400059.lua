local m=31400059
local cm=_G["c"..m]
cm.name="圣狱龙王-托特"
function cm.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedureLevelFree(c,cm.mfilter,cm.xyzcheck,2,99)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetValue(cm.atkval)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCost(cm.cost)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
end
function cm.mfilter(c,xyzc)
	return c:IsRace(RACE_DRAGON) and (c:IsLevelAbove(0) or c:IsRankAbove(0)) and c:IsFaceup()
end
function cm.getlrfilter(c)
  if c:IsLevelAbove(0) then
	return c:GetLevel()
  end
  if c:IsRankAbove(0) then
	return c:GetRank()
  end
end
function cm.xyzcheck(g)
	return g:GetClassCount(cm.getlrfilter)==1
end
function cm.atkval(e,c)
	local M=c:GetOverlayGroup()
	local t=0
	if M:FilterCount(Card.IsType,nil,TYPE_MONSTER)>0 then t=t+1 end
	if M:FilterCount(Card.IsType,nil,TYPE_SPELL)>0 then t=t+1 end
	if M:FilterCount(Card.IsType,nil,TYPE_TRAP)>0 then t=t+1 end
	return t*1000
end
function cm.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST+REASON_RELEASE) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST+REASON_RELEASE)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	local gr=(Duel.GetFieldGroup(tp,0,LOCATION_GRAVE):FilterCount(Card.IsCanOverlay,nil)>0)
	local of=(Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):FilterCount(Card.IsCanOverlay,nil)>0)
	local de=(Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0)
	local con_od=(Duel.GetFlagEffect(tp,m)==0 and of and de)
	local con_gd=(Duel.GetFlagEffect(tp,m+100000000)==0 and gr and de)
	local con_og=(Duel.GetFlagEffect(tp,m+200000000)==0 and of and gr)
	if chk==0 then return (con_od or con_gd or con_og) end
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	local gr=(Duel.GetFieldGroup(tp,0,LOCATION_GRAVE):FilterCount(Card.IsCanOverlay,nil)>0)
	local of=(Duel.GetFieldGroup(tp,0,LOCATION_ONFIELD):FilterCount(Card.IsCanOverlay,nil)>0)
	local de=(Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0)
	local con_od=(Duel.GetFlagEffect(tp,m)==0 and of and de)
	local con_gd=(Duel.GetFlagEffect(tp,m+100000000)==0 and gr and de)
	local con_og=(Duel.GetFlagEffect(tp,m+200000000)==0 and of and gr)
	local op=-1
	if con_od then
		if con_gd then
			if con_og then
				op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2),aux.Stringid(m,3))
			else
				op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,2))
			end
		else
			if con_og then
				op=Duel.SelectOption(tp,aux.Stringid(m,1),aux.Stringid(m,3))
				if op==1 then
					op=2
				end
			else
				op=0
			end
		end
	else
		if con_gd then
			if con_og then
				op=(Duel.SelectOption(tp,aux.Stringid(m,2),aux.Stringid(m,3))+1)
			else
				op=1
			end
		else
			if con_og then
				op=2
			end
		end
	end
	if op==-1 then return end
	local tg
	if op==0 then
		Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		tg=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,1,nil)
		tg:Merge(Duel.GetDecktopGroup(1-tp,1))
		Duel.DisableShuffleCheck()
	end
	if op==1 then
		Duel.RegisterFlagEffect(tp,m+100000000,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		tg=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,0,LOCATION_GRAVE,1,1,nil)
		tg:Merge(Duel.GetDecktopGroup(1-tp,1))
		Duel.DisableShuffleCheck()
	end
	if op==2 then
		Duel.RegisterFlagEffect(tp,m+200000000,RESET_PHASE+PHASE_END,0,1)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		tg=Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,0,LOCATION_ONFIELD,1,1,nil)
		tg:Merge(Duel.SelectMatchingCard(tp,Card.IsCanOverlay,tp,0,LOCATION_GRAVE,1,1,nil))
	end
	Duel.Overlay(c,tg)
end