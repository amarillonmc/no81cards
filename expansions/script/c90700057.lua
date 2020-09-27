local m=90700057
local cm=_G["c"..m]
cm.name="龙战士万化灵仪"
function cm.initial_effect(c)
	local ehand=Effect.CreateEffect(c)
	ehand:SetType(EFFECT_TYPE_SINGLE)
	ehand:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	ehand:SetCondition(cm.handcon)
	c:RegisterEffect(ehand)
	local egain=Effect.CreateEffect(c)
	egain:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	egain:SetCode(EVENT_ADJUST)
	egain:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE)
	egain:SetRange(0xff)
	egain:SetOperation(cm.egainop)
	egain:SetCountLimit(1,m+EFFECT_COUNT_CODE_DUEL)
	c:RegisterEffect(egain)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SUMMON)
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCondition(cm.gravecon)
	e1:SetCost(cm.gravecost)
	e1:SetTarget(cm.gravetg)
	e1:SetOperation(cm.graveop)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SUMMON)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetTarget(cm.sumtg)
	e2:SetOperation(cm.sumop)
	e2:SetLabelObject(e1)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_FIELD)
	e3:SetCode(EVENT_SUMMON_NEGATED)
	e3:SetOperation(cm.sumnegop)
	e3:SetRange(0xff)
	e3:SetLabelObject(e1)
	c:RegisterEffect(e3)
end
function cm.handcon(e)
	return Duel.GetMatchingGroupCount(Card.IsSummonType,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil,SUMMON_TYPE_ADVANCE)==0
end
function cm.egainop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(nil,tp,0x1ff,0x1ff,nil)
	local tc=g:GetFirst()
	while tc do
		local e_adv_su_proc_deck=Effect.CreateEffect(e:GetHandler())
		e_adv_su_proc_deck:SetDescription(aux.Stringid(m,0))
		e_adv_su_proc_deck:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e_adv_su_proc_deck:SetType(EFFECT_TYPE_SINGLE)
		e_adv_su_proc_deck:SetCode(EFFECT_SUMMON_PROC)
		e_adv_su_proc_deck:SetCondition(cm.adv_su_proc_con_deck)
		e_adv_su_proc_deck:SetOperation(cm.adv_su_proc_op_deck)
		e_adv_su_proc_deck:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
		tc:RegisterEffect(e_adv_su_proc_deck,true)
		local e_adv_su_proc_grave=Effect.CreateEffect(e:GetHandler())
		e_adv_su_proc_grave:SetDescription(aux.Stringid(m,1))
		e_adv_su_proc_grave:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
		e_adv_su_proc_grave:SetType(EFFECT_TYPE_SINGLE)
		e_adv_su_proc_grave:SetCode(EFFECT_SUMMON_PROC)
		e_adv_su_proc_grave:SetCondition(cm.adv_su_proc_con_grave)
		e_adv_su_proc_grave:SetOperation(cm.adv_su_proc_op_grave)
		e_adv_su_proc_grave:SetValue(SUMMON_TYPE_ADVANCE+SUMMON_VALUE_SELF)
		tc:RegisterEffect(e_adv_su_proc_grave,true)
		tc=g:GetNext()
	end
end
function cm.adv_deck_cost_filter(c)
	return c:IsAbleToGraveAsCost() and c:IsType(TYPE_MONSTER)
end
function cm.adv_grave_cost_filter(c)
	return c:IsAbleToDeckAsCost() and c:IsType(TYPE_MONSTER)
end
function cm.adv_group_filter(g,lvl)
	return cm.get_races_nums(cm.get_group_races(g))>=lvl
end
function cm.get_group_races(g)
	local races=0
	local tc=g:GetFirst()
	if tc then
		races=tc:GetRace()
		tc=g:GetNext()
	end
	while tc do
		races=bit.bor(races,tc:GetRace())
		tc=g:GetNext()
	end
	return races
end
function cm.get_races_nums(races)
	local res=0
	if not races then
		return res
	end
	while races~=0 do
		races=bit.band(races,races-1)
		res=res+1
	end
	return res
end
function cm.select_g_filter(c,mg)
	local c_race=c:GetRace()
	local tc=mg:GetFirst()
	while tc do
		local tc_race=tc:GetRace()
		local or_res=bit.bor(c_race,tc_race)
		if or_res==c_race or or_res==tc_race then
			return false
		end
		tc=mg:GetNext()
	end
	local races_mg=cm.get_group_races(mg)
	local or_res=bit.bor(c_race,races_mg)
	if races_mg~=0 and (or_res==races_mg or or_res==c_race) then
		return false
	end
	return true
end
function cm.adv_select_cards(g,lvl)
	local mg=Group.CreateGroup()
	while cm.get_races_nums(cm.get_group_races(mg))<lvl do
		local selg=g:Filter(cm.select_g_filter,nil,mg)
		local tc=selg:SelectUnselect(mg,tp,false,false,1,99)
		if not mg:IsContains(tc) then
			mg:AddCard(tc)
		else
			mg:RemoveCard(tc)
		end
	end
	return mg
end
function cm.adv_su_proc_con_deck(e,c,minc)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(cm.adv_deck_cost_filter,tp,LOCATION_DECK,0,c)
	return (Duel.GetFlagEffect(c:GetControler(),m-2)~=0 or c:GetFlagEffect(m-2)~=0) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cm.adv_group_filter(g,c:GetLevel())
end
function cm.adv_su_proc_op_deck(e,tp,eg,ep,ev,re,r,rp,c)
	local lvl=e:GetHandler():GetLevel()
	local g=Duel.GetMatchingGroup(cm.adv_deck_cost_filter,tp,LOCATION_DECK,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local mg=cm.adv_select_cards(g,lvl)
	Duel.SendtoGrave(mg,REASON_COST)
	e:GetHandler():ResetFlagEffect(m-2)
end
function cm.adv_su_proc_con_grave(e,c,minc)
	if c==nil then return true end
	local g=Duel.GetMatchingGroup(cm.adv_grave_cost_filter,tp,LOCATION_GRAVE,0,c)
	return (Duel.GetFlagEffect(c:GetControler(),m-3)~=0 or c:GetFlagEffect(m-3)~=0) and Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and cm.adv_group_filter(g,c:GetLevel())
end
function cm.adv_su_proc_op_grave(e,tp,eg,ep,ev,re,r,rp,c)
	local lvl=e:GetHandler():GetLevel()
	local g=Duel.GetMatchingGroup(cm.adv_grave_cost_filter,tp,LOCATION_GRAVE,0,e:GetHandler())
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
	local mg=cm.adv_select_cards(g,lvl)
	Duel.SendtoDeck(mg,nil,2,REASON_COST)
	e:GetHandler():ResetFlagEffect(m-3)
end
function cm.sumfilter(c)
	return c:IsLevelAbove(5) and (c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1))
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		Duel.RegisterFlagEffect(tp,m-2,0,0,1)
		local con=Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_DECK,0,1,nil)
		Duel.ResetFlagEffect(tp,m-2)
		return con
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m-2,0,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_DECK,0,1,1,nil)
	Duel.ResetFlagEffect(tp,m-2)
	local tc=g:GetFirst()
	if tc then
		e:GetLabelObject():SetLabelObject(tc)
		tc:RegisterFlagEffect(m-2,RESET_EVENT+RESETS_STANDARD,0,1)
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function cm.gravecon(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	return tc and eg:IsContains(tc)
end
function cm.gravecost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		e:SetLabelObject(nil)
		return e:GetHandler():IsAbleToHandAsCost()
	end
	Duel.SendtoHand(e:GetHandler(),nil,REASON_COST)
end
function cm.gravetg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		Duel.RegisterFlagEffect(tp,m-3,0,0,1)
		local con=Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_DECK,0,1,nil)
		Duel.ResetFlagEffect(tp,m-3,0,0,1)
		return con
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,nil,1,0,0)
end
function cm.graveop(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(tp,m-3,0,0,1)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_DECK,0,1,1,nil)
	local tc=g:GetFirst()
	Duel.ResetFlagEffect(tp,m-3,0,0,1)
	if tc then
		tc:RegisterFlagEffect(m-3,RESET_EVENT+RESETS_STANDARD,0,1)
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil,1)
		else
			Duel.MSet(tp,tc,true,nil,1)
		end
	end
end
function cm.sumnegop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject():GetLabelObject()
	local rec=eg:GetFirst()
	while rec do
		rec:ResetFlagEffect(m-2)
		rec:ResetFlagEffect(m-3)
	end
	if eg:IsContains(tc) then
		e:GetLabelObject():SetLabelObject(nil)
	end
end
function cm.assis_op(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():ResetFlagEffect(m-2)
	e:GetHandler():ResetFlagEffect(m-3)
	e:Reset()
end