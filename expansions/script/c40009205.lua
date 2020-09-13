--时机龙骑·刻神指令
function c40009205.initial_effect(c)
	c:EnableReviveLimit()
	aux.EnablePendulumAttribute(c,false)
	aux.AddXyzProcedure(c,c40009205.mfilter,10,3) 
--
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(40009205,0))
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c40009205.PendCondition())
	e1:SetOperation(c40009205.PendOperation())
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1) 
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(40009205,1))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,40009205)
	e2:SetCondition(c40009205.atkcon)
	e2:SetOperation(c40009205.atkop)
	c:RegisterEffect(e2)  
	--pendulum
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(40009205,4))
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCondition(c40009205.pencon)
	e4:SetTarget(c40009205.pentg)
	e4:SetOperation(c40009205.penop)
	c:RegisterEffect(e4) 
end
function c40009205.mfilter(c)
	return c:IsType(TYPE_PENDULUM) and c:IsAttribute(ATTRIBUTE_DARK)
end
function c40009205.PConditionFilter(c,e,tp)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=aux.PendulumSummonableBool(c)
	return  (c:IsLocation(LOCATION_HAND) 
		or c:IsLocation(LOCATION_REMOVED)
		or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and c:IsSetCard(0xf1c)
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,bool,bool)
		and not c:IsForbidden()
end
--
function c40009205.PendCondition()
	return
	function(e,c,og)
		if c==nil then return true end
		local tp=c:GetControler()
		local seq=c:GetSequence()
		local loc=0
		local LE=Duel.GetLocationCountFromEx(tp)
		local LM=Duel.GetLocationCount(tp,LOCATION_MZONE)
		if LE>0 then loc=loc+LOCATION_EXTRA end
		if LM>0 then loc=loc+LOCATION_HAND+LOCATION_REMOVED end
		if loc==0 then return false end
		local g=nil
		if og then
			g=og:Filter(Card.IsLocation,nil,loc)
		else
			g=Duel.GetFieldGroup(tp,loc,0)
		end
		return g:IsExists(c40009205.PConditionFilter,1,nil,e,tp)
		   
	end
end
--
function c40009205.PendOperation()
	return  
	function(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
		local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
		local ft2=Duel.GetLocationCountFromEx(tp)
		local ft=Duel.GetUsableMZoneCount(tp)
		if Duel.IsPlayerAffectedByEffect(tp,59822133) then
			if ft1>0 then ft1=1 end
			if ft2>0 then ft2=1 end
			ft=1
		end
		local loc=0
		if ft1>0 then loc=loc+LOCATION_HAND+LOCATION_REMOVED end
		if ft2>0 then loc=loc+LOCATION_EXTRA end
		local tg=nil
		if og then
			tg=og:Filter(Card.IsLocation,nil,loc):Filter(c40009205.PConditionFilter,nil,e,tp)
		else
			tg=Duel.GetMatchingGroup(c40009205.PConditionFilter,tp,loc,0,nil,e,tp)
		end
		ft1=math.min(ft1,tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_REMOVED))
		ft2=math.min(ft2,tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA))
		local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
		if ect and ect<ft2 then ft2=ect end
		while true do
			local ct1=tg:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_REMOVED)
			local ct2=tg:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
			local ct=ft
			if ct1>ft1 then ct=math.min(ct,ft1) end
			if ct2>ft2 then ct=math.min(ct,ft2) end
			if ct<=0 then break end
			if sg:GetCount()>0 and not Duel.SelectYesNo(tp,210) then ft=0 break end
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local g=tg:Select(tp,1,ct,nil)
			tg:Sub(g)
			sg:Merge(g)
			if g:GetCount()<ct then ft=0 break end
			ft=ft-g:GetCount()
			ft1=ft1-g:FilterCount(Card.IsLocation,nil,LOCATION_HAND+LOCATION_REMOVED)
			ft2=ft2-g:FilterCount(Card.IsLocation,nil,LOCATION_EXTRA)
		end
		if ft>0 then
			local tg1=tg:Filter(Card.IsLocation,nil,LOCATION_HAND+LOCATION_REMOVED)
			local tg2=tg:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
			if ft1>0 and ft2==0 and tg1:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
				local ct=math.min(ft1,ft)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=tg1:Select(tp,1,ct,nil)
				sg:Merge(g)
			end
			if ft1==0 and ft2>0 and tg2:GetCount()>0 and (sg:GetCount()==0 or Duel.SelectYesNo(tp,210)) then
				local ct=math.min(ft2,ft)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				local g=tg2:Select(tp,1,ct,nil)
				sg:Merge(g)
			end
		end
		Duel.HintSelection(Group.FromCards(c))
	end
end
function c40009205.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009205.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_CHAIN_SOLVING)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetCost(c40009205.drcost)
	e1:SetCondition(c40009205.discon2)
	e1:SetOperation(c40009205.disop2)
	Duel.RegisterEffect(e1,tp)
end
function c40009205.crfilter(c)
	return c:IsFaceup() c:IsSetCard(0xf1c) and c:IsType(TYPE_MONSTER) and c:IsAbleToDeckAsCost()
end
function c40009205.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c40009205.crfilter,tp,LOCATION_REMOVED,0,2,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local g=Duel.SelectMatchingCard(tp,c40009205.crfilter,tp,LOCATION_REMOVED,0,2,2,nil)
	Duel.SendtoDeck(g,nil,2,REASON_COST)
end
function c40009205.discon2(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsChainDisablable(ev) and rp~=tp 
end
function c40009205.disop2(e,tp,eg,ep,ev,re,r,rp)
	if Duel.SelectYesNo(tp,aux.Stringid(40009205,2)) then
		Duel.Hint(HINT_CARD,0,40009205)
		Duel.Hint(HINT_OPSELECTED,1-tp,aux.Stringid(40009205,3))
		if Duel.NegateEffect(ev) and re:GetHandler():IsRelateToEffect(re) then
			Duel.Remove(eg,POS_FACEUP,REASON_EFFECT)
		end
	end
end
function c40009205.pencon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsSummonType(SUMMON_TYPE_XYZ)
end
function c40009205.pentg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1) end
end
function c40009205.penfilter(c,e,tp)
	return (c:IsLocation(LOCATION_GRAVE) or c:IsFaceup()) and c:IsSetCard(0xf1c) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c40009205.penop(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.CheckLocation(tp,LOCATION_PZONE,0) and not Duel.CheckLocation(tp,LOCATION_PZONE,1) then return false end
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and Duel.MoveToField(c,tp,tp,LOCATION_PZONE,POS_FACEUP,true) then
		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
		local g=Duel.GetMatchingGroup(aux.NecroValleyFilter(c40009205.penfilter),tp,LOCATION_GRAVE+LOCATION_REMOVED,0,nil,e,tp)
		if g:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(40009205,5)) then
			Duel.BreakEffect()
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
			local sg=g:Select(tp,1,1,nil)
			Duel.SpecialSummon(sg,0,tp,tp,false,false,POS_FACEUP)
		end
	end
end
