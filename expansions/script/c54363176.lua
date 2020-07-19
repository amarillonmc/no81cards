--冥界的骨魔王 哈·迪斯
function c54363176.initial_effect(c)
	--link
	aux.AddLinkProcedure(c,c54363176.lkcheck,2,4)
	c:EnableReviveLimit()
	--cannot be target
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e1:SetTarget(c54363176.tgtg)
	e1:SetValue(c54363176.indval)
	c:RegisterEffect(e1)
	--indes
	local e2=e1:Clone()
	e2:SetCode(EFFECT_CANNOT_BE_EFFECT_TARGET)
	e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
	c:RegisterEffect(e2)
	--Disable
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetOperation(c54363176.operation)
	c:RegisterEffect(e3)
	--spsummon limit
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetTargetRange(1,1)
	e4:SetTarget(c54363176.sumlimit)
	c:RegisterEffect(e4)
	--activate limit
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_FIELD)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCode(EFFECT_CANNOT_ACTIVATE)
	e5:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e5:SetTargetRange(1,1)
	e5:SetTarget(c54363176.aclimit)
	c:RegisterEffect(e5)
	--Activate
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(54363176,0))
	e6:SetCategory(CATEGORY_SPECIAL_SUMMON+CATEGORY_CONTROL+CATEGORY_TODECK)
	e6:SetType(EFFECT_TYPE_QUICK_O)
	e6:SetCode(EVENT_FREE_CHAIN)
	e6:SetRange(LOCATION_MZONE)
	e6:SetHintTiming(0,0x1e0)
	e6:SetCountLimit(1,54363176)
	e6:SetCondition(c54363176.hscon)
	e6:SetTarget(c54363176.hsptg)
	e6:SetOperation(c54363176.hspop)
	c:RegisterEffect(e6)
	Duel.AddCustomActivityCounter(54363176,ACTIVITY_CHAIN,c54363176.chainfilter)
end
function c54363176.chainfilter(re,tp,cid)
	return re:GetHandler():IsSetCard(0x1400) or re:GetHandler():IsRace(RACE_ZOMBIE) or re:GetHandler():IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807)
end
function c54363176.lkcheck(c)
	return c:IsRace(RACE_ZOMBIE) or c:IsSetCard(0x1400) or c:IsCode(8198620,21435914,22657402,53982768,66547759,75043725,89272878,89732524,96163807)
end
function c54363176.hscon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()~=tp
end
function c54363176.tgtg(e,c)
	return c:IsRace(RACE_ZOMBIE)
end
function c54363176.indval(e,re,rp)
	return true
end
function c54363176.sumlimit(e,c,sump,sumtype,sumpos,targetp)
	return c:IsLocation(LOCATION_GRAVE) and not c:IsRace(RACE_ZOMBIE)
end
function c54363176.effilter1(c,e,sump,sumtype,sumpos,targetp)
	return c:IsType(TYPE_MONSTER) and c:IsRace(RACE_ZOMBIE)
end
function c54363176.effilter2(c,e,tp,zone)
	return c:IsType(TYPE_MONSTER) and c:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEUP,tp,zone) and c:IsAbleToChangeControler()
end
function c54363176.effilter3(c,e,tp)
	return c:IsRace(RACE_ZOMBIE) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c54363176.aclimit(e,re,tp,c)
	return re:GetActivateLocation()==LOCATION_GRAVE and re:GetHandler():IsType(TYPE_MONSTER) and not re:GetHandler():IsRace(RACE_ZOMBIE) 
end
function c54363176.operation(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	local p=Duel.GetAttacker():GetControler()
	if d==nil then return end
	local tc=nil
	if a:GetControler()==p and a:IsRace(RACE_ZOMBIE) and d:IsStatus(STATUS_BATTLE_DESTROYED) then tc=d
	elseif d:GetControler()==p and d:IsRace(RACE_ZOMBIE) and a:IsStatus(STATUS_BATTLE_DESTROYED) then tc=a end
	if not tc then return end
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_DISABLE)
	e1:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e1)
	local e2=Effect.CreateEffect(e:GetHandler())
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DISABLE_EFFECT)
	e2:SetReset(RESET_EVENT+0x17a0000)
	tc:RegisterEffect(e2)
end
function c54363176.hsptg(e,tp,eg,ep,ev,re,r,rp,chk)
	local zone=e:GetHandler():GetLinkedZone()
	local b1=Duel.IsExistingMatchingCard(c54363176.effilter1,tp,LOCATION_HAND+LOCATION_GRAVE+LOCATION_MZONE,0,1,nil,e,tp)
	local b2=(zone~=0 and Duel.IsExistingMatchingCard(c54363176.effilter2,1-tp,LOCATION_HAND,0,1,nil,e,1-tp,zone))
	local b3=Duel.IsExistingMatchingCard(c54363176.effilter3,tp,LOCATION_HAND+LOCATION_GRAVE,0,1,nil,e,tp) and Duel.GetLocationCount(1-tp,LOCATION_MZONE)>0
	if chk==0 then return b1 or b2 or b3 end
	local ops,opval,g={},{}
	local off=1
	if b1 then
		ops[off]=aux.Stringid(54363176,1)
		opval[off-1]=1
		off=off+1
	end
	if b2 then
		ops[off]=aux.Stringid(54363176,2)
		opval[off-1]=2
		off=off+1
	end
	if b3 then
		ops[off]=aux.Stringid(54363176,3)
		opval[off-1]=3
		off=off+1
	end
	local op=Duel.SelectOption(tp,table.unpack(ops))
	local sel=opval[op]
	e:SetLabel(sel)
	if sel==1 then
		e:SetCategory(CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,0,PLAYER_ALL,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE)
	elseif sel==2 then
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,1-tp,LOCATION_HAND)
	else
		e:SetCategory(CATEGORY_SPECIAL_SUMMON)
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
	end
end
function c54363176.hspop(e,tp,eg,ep,ev,re,r,rp)
	local sel,g=e:GetLabel()
	local g1=e:GetLabel()
	local zone=e:GetHandler():GetLinkedZone()
	if sel==1 then
		local g=Duel.SelectMatchingCard(tp,c54363176.effilter1,tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,tp)
		local g1=Duel.SelectMatchingCard(1-tp,c54363176.effilter1,1-tp,LOCATION_MZONE+LOCATION_HAND+LOCATION_GRAVE,0,1,1,nil,e,1-tp)
		if g:GetCount()>0 and g1:GetCount()>0 then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local sg=g:Select(tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,tp,0,REASON_RULE)
			Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_TODECK)
			local sg=g1:Select(1-tp,1,1,nil)
			Duel.HintSelection(sg)
			Duel.SendtoDeck(sg,1-tp,0,REASON_RULE)
		end
	elseif sel==2 then
		if Duel.GetFieldGroupCount(tp,0,LOCATION_HAND)==0 then return end
		if zone==0 then return end
		local g=Duel.GetFieldGroup(1-tp,LOCATION_HAND,0)
		Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_SPSUMMON)
		local g1=Duel.SelectMatchingCard(1-tp,c54363176.effilter2,1-tp,LOCATION_HAND,0,1,1,nil,e,1-tp,zone)
		Duel.ConfirmCards(tp,g)
		if g:GetCount()>0 then
			Duel.SpecialSummon(g1,0,tp,tp,false,false,POS_FACEUP,zone)
		end
		Duel.ShuffleHand(1-tp)
		Duel.SpecialSummonComplete()
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local g=Duel.SelectMatchingCard(tp,c54363176.effilter3,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil,e,tp)
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
		Duel.SpecialSummonComplete()
	end
end