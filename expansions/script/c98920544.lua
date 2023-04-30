--装弹枪管刑罚龙
function c98920544.initial_effect(c)
 --pendulum summon
	aux.EnablePendulumAttribute(c)
--psrt
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1163)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC_G)
	e1:SetRange(LOCATION_PZONE)
	e1:SetCondition(c98920544.PendCondition)
	e1:SetOperation(c98920544.PendOperation)
	e1:SetValue(SUMMON_TYPE_PENDULUM)
	c:RegisterEffect(e1)
	if not c98920544.PendulumChecklist then
		c98920544.PendulumChecklist=0
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(c98920544.PendulumReset)
		Duel.RegisterEffect(ge1,0)
	end
--atk
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(98920544,1))
	e2:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_TOEXTRA)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCountLimit(1,98920544)
	e2:SetTarget(c98920544.atktg)
	e2:SetOperation(c98920544.atkop)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetCondition(c98920544.condition1)
	c:RegisterEffect(e3)
--actlimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_FIELD)
	e6:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e6:SetCode(EFFECT_CANNOT_ACTIVATE)
	e6:SetRange(LOCATION_MZONE)
	e6:SetTargetRange(0,1)
	e6:SetValue(1)
	e6:SetCondition(c98920544.actcon)
	c:RegisterEffect(e6)
end
function c98920544.actcon(e)
	return Duel.GetAttacker()==e:GetHandler() or Duel.GetAttackTarget()==e:GetHandler()
end
function c98920544.condition1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_PENDULUM)
end
function c98920544.PendulumReset(e,tp,eg,ep,ev,re,r,rp)
	c98920544.PendulumChecklist=0
end
function c98920544.PConditionExtraFilterSpecific(c,e,tp,lscale,rscale,te)
	if not te then return true end
	local f=te:GetValue()
	return not f or f(te,c,e,tp,lscale,rscale)
end
function c98920544.PConditionExtraFilter(c,e,tp,lscale,rscale,eset)
	for _,te in ipairs(eset) do
		if c98920544.PConditionExtraFilterSpecific(c,e,tp,lscale,rscale,te) then return true end
	end
	return false
end
function c98920544.PConditionFilter(c,e,tp,eset)
	local lv=0
	if c.pendulum_level then
		lv=c.pendulum_level
	else
		lv=c:GetLevel()
	end
	local bool=Auxiliary.PendulumSummonableBool(c)
	return (c:IsLocation(LOCATION_HAND) or (c:IsFaceup() and c:IsType(TYPE_PENDULUM)))
		and lv>0 and lv<10 and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_PENDULUM,tp,nil,nil)
		and not c:IsForbidden() and c:IsSetCard(0x10f,0x102)
		and (c98920544.PendulumChecklist&(0x1<<tp)==0 or c98920544.PConditionExtraFilter(c,e,tp,eset))
end
function c98920544.PendCondition(e,c,og)
				if c==nil then return true end
				local tp=c:GetControler()
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				if c98920544.PendulumChecklist&(0x1<<tp)~=0 and #eset==0 then return false end
				local lscale=9
				local rscale=0
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local loc=0
				if Duel.GetLocationCount(tp,LOCATION_MZONE)>0 then loc=loc+LOCATION_HAND end
				if Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)>0 then loc=loc+LOCATION_EXTRA end
				if loc==0 then return false end
				local g=nil
				if og then
					g=og:Filter(Card.IsLocation,nil,loc)
				else
					g=Duel.GetFieldGroup(tp,loc,0)
				end
				return g:IsExists(c98920544.PConditionFilter,1,nil,e,tp,lscale,rscale,eset) and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0 and (Duel.CheckLocation(tp,LOCATION_PZONE,0) or Duel.CheckLocation(tp,LOCATION_PZONE,1))
end
function c98920544.PendOperationCheck(ft1,ft2,ft)
	return  function(g)
				local exg=g:Filter(Card.IsLocation,nil,LOCATION_EXTRA)
				local mg=g-exg
				return #g<=ft and #exg<=ft2 and #mg<=ft1
			end
end
function c98920544.PendOperation(e,tp,eg,ep,ev,re,r,rp,c,sg,og)
				local tp=e:GetHandlerPlayer()
				local lscale=9
				local rscale=0
				if lscale>rscale then lscale,rscale=rscale,lscale end
				local eset={Duel.IsPlayerAffectedByEffect(tp,EFFECT_EXTRA_PENDULUM_SUMMON)}
				local tg=nil
				local loc=0
				local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
				local ft2=Duel.GetLocationCountFromEx(tp,tp,nil,TYPE_PENDULUM)
				local ft=Duel.GetUsableMZoneCount(tp)
				local ect=c29724053 and Duel.IsPlayerAffectedByEffect(tp,29724053) and c29724053[tp]
				if ect and ect<ft2 then ft2=ect end
				if Duel.IsPlayerAffectedByEffect(tp,59822133) then
					if ft1>0 then ft1=1 end
					if ft2>0 then ft2=1 end
					ft=1
				end
				if ft1>0 then loc=loc|LOCATION_HAND end
				if ft2>0 then loc=loc|LOCATION_EXTRA end
				if og then
					tg=og:Filter(Card.IsLocation,nil,loc):Filter(c98920544.PConditionFilter,nil,e,tp,eset)
				else
					tg=Duel.GetMatchingGroup(c98920544.PConditionFilter,tp,loc,0,nil,e,tp,eset)
				end
				local ce=nil
				local b1=c98920544.PendulumChecklist&(0x1<<tp)==0
				local b2=#eset>0
				if b1 and b2 then
					local options={1163}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					if op>0 then
						ce=eset[op]
					end
				elseif b2 and not b1 then
					local options={}
					for _,te in ipairs(eset) do
						table.insert(options,te:GetDescription())
					end
					local op=Duel.SelectOption(tp,table.unpack(options))
					ce=eset[op+1]
				end
				if ce then
					tg=tg:Filter(c98920544.PConditionExtraFilterSpecific,nil,e,tp,lscale,rscale,ce)
				end
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
				c98920544.GCheckAdditional=c98920544.PendOperationCheck(ft1,ft2,ft)
				local g=tg:SelectSubGroup(tp,aux.TRUE,true,1,math.min(#tg,ft))
				c98920544.GCheckAdditional=nil
				if not g then return end
				if ce then
					Duel.Hint(HINT_CARD,0,ce:GetOwner():GetOriginalCode())
					ce:UseCountLimit(tp)
				else
					c98920544.PendulumChecklist=c98920544.PendulumChecklist|(0x1<<tp)
				end
				sg:Merge(g)
				Duel.HintSelection(Group.FromCards(c))
				Duel.HintSelection(Group.FromCards(rpz))
				local num=sg:GetCount()
				local lp=Duel.GetLP(tp)
				Duel.SetLP(tp,lp-num*500)
end
function c98920544.atktg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and chkc:IsType(TYPE_LINK) end
	if chk==0 then return true end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,Card.IsType,tp,LOCATION_GRAVE,0,1,1,nil,TYPE_LINK)
	Duel.SetChainLimit(c98920544.chlimit)
end
function c98920544.chlimit(e,ep,tp)
	return tp==ep
end
function c98920544.atkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc or not tc:IsRelateToEffect(e) then return end
	local atk=tc:GetAttack()
	if c:IsRelateToEffect(e) and c:IsFaceup() and Duel.SendtoDeck(tc,nil,SEQ_DECKSHUFFLE,REASON_EFFECT)~=0 then
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	end
end