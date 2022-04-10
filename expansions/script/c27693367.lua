--命运女郎·艾妮
function c27693367.initial_effect(c)
	c:EnableReviveLimit()
	--spsummon condition
	local e01=Effect.CreateEffect(c)
	e01:SetType(EFFECT_TYPE_SINGLE)
	e01:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e01:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e01)
	--special summon rule
	local e02=Effect.CreateEffect(c)
	e02:SetType(EFFECT_TYPE_FIELD)
	e02:SetCode(EFFECT_SPSUMMON_PROC)
	e02:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e02:SetRange(LOCATION_EXTRA)
	e02:SetCondition(c27693367.sprcon)
	e02:SetOperation(c27693367.sprop)
	c:RegisterEffect(e02)
	--synchro custom
	local e03=Effect.CreateEffect(c)
	e03:SetType(EFFECT_TYPE_SINGLE)
	e03:SetCode(EFFECT_SYNCHRO_MATERIAL_CUSTOM)
	e03:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e03:SetTarget(c27693367.syntg)
	e03:SetValue(1)
	e03:SetOperation(c27693367.synop)
	c:RegisterEffect(e03)

	--normal effect
	--atk,def
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCode(EFFECT_SET_ATTACK)
	e1:SetValue(c27693367.value)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EFFECT_SET_DEFENSE)
	c:RegisterEffect(e2)
	--level up
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(27693367,0))
	e3:SetCategory(CATEGORY_REMOVE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e3:SetCondition(c27693367.lvcon)
	e3:SetOperation(c27693367.lvop)
	c:RegisterEffect(e3)
	--level up&down
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCost(c27693367.lvcost)
	e4:SetOperation(c27693367.lvop2)
	c:RegisterEffect(e4)
end
function c27693367.tgrfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(1) and c:IsAbleToGraveAsCost() and c:IsSetCard(0x31)
end
function c27693367.mnfilter(c,g)
	return g:IsExists(c27693367.mnfilter2,1,c,c)
end
function c27693367.mnfilter2(c,mc)
	return c:GetLevel()-mc:GetLevel()==1
end
function c27693367.fselect(g,tp,sc)
	return g:GetCount()>=2
		and g:IsExists(c27693367.mnfilter,1,nil,g)
		and Duel.GetLocationCountFromEx(tp,tp,g,sc)>0
end
function c27693367.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c27693367.tgrfilter,tp,LOCATION_MZONE,0,nil)
	return g:CheckSubGroup(c27693367.fselect,2,2,tp,c)
end
function c27693367.sprop(e,tp,eg,ep,ev,re,r,rp,c)
	local g=Duel.GetMatchingGroup(c27693367.tgrfilter,tp,LOCATION_MZONE,0,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local tg=g:SelectSubGroup(tp,c27693367.fselect,false,2,2,tp,c)
	Duel.SendtoGrave(tg,REASON_COST)
end
function c27693367.synfilter(c,syncard,tuner,f)
	return (c:IsFaceup() or (c:IsLocation(LOCATION_HAND) and c:IsSetCard(0x31))) and c:IsCanBeSynchroMaterial(syncard,tuner) and (f==nil or f(c,syncard))
end
function c27693367.syncheck(c,g,mg,tp,lv,syncard,minc,maxc)
	g:AddCard(c)
	local ct=g:GetCount()
	local res=c27693367.syngoal(g,tp,lv,syncard,minc,ct)
		or (ct<maxc and mg:IsExists(c27693367.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc))
	g:RemoveCard(c)
	return res
end
function c27693367.syngoal(g,tp,lv,syncard,minc,ct)
	return ct>=minc
		and g:CheckWithSumEqual(Card.GetSynchroLevel,lv,ct,ct,syncard)
		and Duel.GetLocationCountFromEx(tp,tp,g,syncard)>0
end
function c27693367.syntg(e,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local tp=syncard:GetControler()
	local lv=syncard:GetLevel()
	if lv<=c:GetLevel() then return false end
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(c27693367.synfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,c,syncard,c,f)
	return mg:IsExists(c27693367.syncheck,1,g,g,mg,tp,lv,syncard,minc,maxc)
end
function c27693367.synop(e,tp,eg,ep,ev,re,r,rp,syncard,f,min,max)
	local minc=min+1
	local maxc=max+1
	local c=e:GetHandler()
	local lv=syncard:GetLevel()
	local g=Group.FromCards(c)
	local mg=Duel.GetMatchingGroup(c27693367.synfilter,tp,LOCATION_MZONE+LOCATION_HAND,LOCATION_MZONE,c,syncard,c,f)
	for i=1,maxc do
		local cg=mg:Filter(c27693367.syncheck,g,g,mg,tp,lv,syncard,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c27693367.syngoal(g,tp,lv,syncard,minc,i) then
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SMATERIAL)
		local sg=cg:Select(tp,minct,1,nil)
		if sg:GetCount()==0 then break end
		g:Merge(sg)
	end
	Duel.SetSynchroMaterial(g)
end


function c27693367.value(e,c)
	return c:GetLevel()*500
end
function c27693367.lvcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp
end
function c27693367.lvop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsFacedown() or not c:IsRelateToEffect(e) or c:IsLevelAbove(12) then return end
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_LEVEL)
	e1:SetValue(1)
	e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
	c:RegisterEffect(e1)
	local sg=Duel.GetMatchingGroup(Card.IsAbleToHand,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	if sg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(27693367,2)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local tg=sg:Select(tp,1,1,nil)
		Duel.BreakEffect()
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
	end
end

function c27693367.lvfilter(c,tp)
	return c:GetOwner()==tp and c:IsRace(RACE_SPELLCASTER)
end
function c27693367.lvcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.GetMatchingGroup(Card.IsAbleToRemoveAsCost,tp,LOCATION_GRAVE,0,nil)
	local sg=g:Select(tp,1,99,nil)
	e:SetLabel(Duel.Remove(sg,POS_FACEUP,REASON_COST))
end
function c27693367.lvop2(e,tp,eg,ep,ev,re,r,rp)
	local lvl=e:GetLabel()
	if Duel.SelectOption(tp,aux.Stringid(27693367,1),aux.Stringid(27693367,2))==1 then
		lvl=-e:GetLabel()
	end
	local c=e:GetHandler()
	local hg=Duel.GetMatchingGroup(Card.IsRace,tp,LOCATION_HAND,0,nil,RACE_SPELLCASTER)
	local tc=hg:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lvl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetCode(EVENT_TO_HAND)
	e2:SetReset(RESET_PHASE+PHASE_END)
	e2:SetLabel(lvl)
	e2:SetOperation(c27693367.hlvop)
	Duel.RegisterEffect(e2,tp)
end
function c27693367.hlvop(e,tp,eg,ep,ev,re,r,rp)
	local hg=eg:Filter(c27693367.lvfilter,nil,tp)
	local tc=hg:GetFirst()
	local lvl=e:GetLabel()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_LEVEL)
		e1:SetValue(lvl)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=hg:GetNext()
	end
end
