--绘舞华·星彩之缤色花
--21.07.29
local m=11451610
local cm=_G["c"..m]
function cm.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,3,3,cm.lcheck)
	c:EnableReviveLimit()
	--effect1
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetTarget(cm.thtg)
	e1:SetOperation(cm.thop)
	c:RegisterEffect(e1)
	--effect2
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCode(EVENT_PHASE+PHASE_END)
	e2:SetTarget(cm.tg)
	e2:SetOperation(cm.op)
	c:RegisterEffect(e2)
	if not cm.global_check then
		cm.global_check=true
		cm.list={1054,1066,1057,1067,1068,1069}
		cm.list2={0x2,0x10002,0x82,0x20002,0x40002,0x80002}
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_PHASE_START+PHASE_DRAW)
		ge1:SetOperation(cm.clear)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.clear(e,tp,eg,ep,ev,re,r,rp)
	cm.list={1054,1066,1057,1067,1068,1069}
	cm.list2={0x2,0x10002,0x82,0x20002,0x40002,0x80002}
end
function cm.lcheck(g,lc)
	return g:GetClassCount(Card.GetLinkCode)==#g
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return #cm.list>=3 end
end
function cm.thfilter(c,typ)
	return c:GetType()&typ==typ and c:IsAbleToHand() and (typ~=0x2 or c:GetType()==0x2)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local list={}
	local list2={}
	for i=1,3 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
		local a=Duel.SelectOption(tp,table.unpack(cm.list))
		list[i]=cm.list[a+1]
		list2[i]=cm.list2[a+1]
		table.remove(cm.list,a+1)
		table.remove(cm.list2,a+1)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	local b=Duel.SelectOption(1-tp,table.unpack(list))
	local typ=list2[b+1]
	local rg=Group.CreateGroup()
	local i=0
	local p=tp
	while i<=1 do
		local g=Duel.GetMatchingGroup(cm.thfilter,p,LOCATION_DECK,0,nil,typ)
		if #g>0 and Duel.SelectYesNo(p,aux.Stringid(m,2)) then
			local sg=g:Select(p,1,1,nil)
			rg:Merge(sg)
		end
		i=i+1
		p=1-tp
	end
	if #rg>0 then
		Duel.SendtoHand(rg,nil,REASON_EFFECT)
		Duel.ConfirmCards(tp,rg)
		Duel.ConfirmCards(1-tp,rg)
	end
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsFacedown,tp,LOCATION_EXTRA,0,1,nil) and Duel.IsPlayerCanSpecialSummon(tp) and Duel.GetMZoneCount(tp)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	if not Duel.IsPlayerCanSpecialSummon(tp) or Duel.GetMatchingGroupCount(Card.IsFacedown,tp,LOCATION_EXTRA,0,nil)==0 then return end
	Duel.ShuffleExtra(tp)
	Duel.ConfirmExtratop(tp,1)
	local tc=Duel.GetExtraTopGroup(tp,1):GetFirst()
	if tc:IsSetCard(0x97f) and Duel.GetLocationCountFromEx(tp,tp,nil,tc)>0 and tc:IsCanBeSpecialSummoned(e,0,tp,false,false) then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	elseif not tc:IsSetCard(0x97f) or not tc:IsType(TYPE_MONSTER) then
		Duel.SendtoGrave(tc,REASON_EFFECT)
	end
end