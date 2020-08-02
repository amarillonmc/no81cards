--星煌之龙战士
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130002001)
function cm.initial_effect(c)
	--summon with 1 tribute
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_SUMMON_PROC)
	e1:SetCondition(cm.otcon)
	e1:SetOperation(cm.otop)
	e1:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e1)
	local e2=rsef.RegisterClone(c,e1,"code",EFFECT_SET_PROC)
	local e3=rsef.I(c,{m,1},nil,"th,se,sum",nil,LOCATION_MZONE,cm.sumcon2,nil,rsop.target(cm.thfilter,"th",LOCATION_DECK),cm.sumop2)
	--summon
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_SUMMON)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetRange(LOCATION_HAND)
	e4:SetCode(EVENT_FREE_CHAIN)
	e4:SetCountLimit(1,m)
	e4:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_MAIN_END)
	e4:SetTarget(cm.sumtg)
	e4:SetOperation(cm.sumop)
	c:RegisterEffect(e4)
end
function cm.tgfilter(c)
	return c:IsAbleToGraveAsCost() and c:IsAttack(2400,2800) and c:IsDefense(1000)
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.tgfilter,tp,LOCATION_DECK,0,nil)
	return c:IsLevelAbove(5) and minc<=1 and #mg>0 and cm.switch
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	cm.switch=false
	c:SetMaterial(Group.CreateGroup())
	local ct,og,tc=rsop.SelectToGrave(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil,{REASON_SUMMON+REASON_COST })
	if not tc then return end 
	local code=tc:GetCode()
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_CHANGE_CODE)
	e2:SetValue(code)
	e2:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	c:RegisterEffect(e2)
	c:CopyEffect(code,RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD,1)
	if not tc:IsLocation(LOCATION_GRAVE) then return end
	local fid=tc:GetFieldID()
	tc:RegisterFlagEffect(m,rsreset.est,0,1,fid)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE)
	e7:SetRange(LOCATION_MZONE)
	e7:SetCode(EFFECT_SELF_DESTROY)
	e7:SetReset(RESET_EVENT+RESETS_STANDARD-RESET_TOFIELD)
	e7:SetCondition(cm.descon)
	c:RegisterEffect(e7)
	e7:SetLabel(fid)
end
function cm.descon(e)
	return not Duel.IsExistingMatchingCard(cm.descfilter,tp,LOCATION_GRAVE,LOCATION_GRAVE,1,nil,e:GetLabel())
end
function cm.descfilter(c,fid)
	return c:GetFlagEffectLabel(m)==fid
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then 
		cm.switch=true
		local res=c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1) cm.switch=false
		return res
	end
	Duel.SetOperationInfo(0,CATEGORY_SUMMON,c,1,0,0)
end
function cm.sumop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	cm.switch=true
	local pos=0
	if c:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if c:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 then return end
	Duel.BreakEffect()
	if Duel.SelectPosition(tp,c,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,c,true,nil,1)
	else
		Duel.MSet(tp,c,true,nil,1)
	end
end
function cm.sumcon2(e,tp)
	return not Duel.IsExistingMatchingCard(cm.sumcfilter,tp,0,LOCATION_MZONE,1,nil)
end
function cm.sumcfilter(c)
	return c:IsFaceup() and c:IsSummonableCard()
end
function cm.thfilter(c)
	return c:IsSummonableCard() and c:IsLevelAbove(5) and c:IsAbleToHand()
end
function cm.sumop2(e,tp)
	local ct,og,tc=rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if not tc then return end
	local pos=0
	if tc:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if tc:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 or not rsop.SelectYesNo(tp,{m,3}) then return end
	if Duel.SelectPosition(tp,tc,pos)==POS_FACEUP_ATTACK then
		Duel.Summon(tp,tc,true,nil,1)
	else
		Duel.MSet(tp,tc,true,nil,1)
	end
end