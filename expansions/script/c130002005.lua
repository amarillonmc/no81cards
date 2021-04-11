--龙战士的托宣 
if not pcall(function() require("expansions/script/c10199990") end) then require("script/c10199990") end
local m,cm=rscf.DefineCard(130002005)
function cm.initial_effect(c)

	rsef.CreatEvent_Set()

	--act in hand
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e0:SetCondition(cm.handcon)
	c:RegisterEffect(e0)   

	local e1=rsef.ACT(c,nil,nil,nil,"se,th,sum",nil,nil,nil,nil,cm.act)
	

	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,2))
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_SUMMON_PROC)
	e3:SetTargetRange(LOCATION_HAND,0)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(cm.ttcon2)
	e3:SetTarget(aux.TargetBoolFunction(Card.IsLevelAbove,5))
	e3:SetOperation(cm.ttop2)
	e3:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e3)

	local e5=rsef.RegisterClone(c,e3,"code",EFFECT_SET_PROC)

	local e4=rsef.FTO(c,rscode.Set,{m,2},nil,"sum")
	
	e4:SetRange(LOCATION_SZONE)
	rsef.RegisterSolve(e4,cm.sumcon,nil,nil,cm.sumop)

end

function cm.sumfilter(c)
	return c:IsSummonable(true,nil,1) or c:IsMSetable(true,nil,1)
end
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	cm.switch=eg
	local res=tp~=ep and eg:IsExists(Card.IsAbleToDeckOrExtraAsCost,1,nil) and Duel.IsExistingMatchingCard(cm.sumfilter,tp,LOCATION_HAND,0,1,nil)
	cm.switch=false
	return res
end
function cm.sumop(e,tp,eg)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	eg:KeepAlive()
	cm.switch=eg
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
	local g=Duel.SelectMatchingCard(tp,cm.sumfilter,tp,LOCATION_HAND,0,1,1,nil)
	local tc=g:GetFirst()
	if tc then
		local s1=tc:IsSummonable(true,nil,1)
		local s2=tc:IsMSetable(true,nil,1)
		if (s1 and s2 and Duel.SelectPosition(tp,tc,POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)==POS_FACEUP_ATTACK) or not s2 then
			Duel.Summon(tp,tc,true,nil)
		else
			Duel.MSet(tp,tc,true,nil)
		end
	end
end


function cm.ttcon2(e,c,minc)
	if c==nil then return true end
	return c:IsLevelAbove(5) and cm.switch
end
function cm.ttop2(e,tp,eg,ep,ev,re,r,rp,c)  
	c:SetMaterial(Group.CreateGroup())
	Duel.SendtoDeck(cm.switch,nil,2,REASON_COST+REASON_SUMMON)
	cm.switch=false
end

function cm.cfilter(c)
	return c:IsSummonType(SUMMON_TYPE_ADVANCE)
end
function cm.handcon(e)
	return not Duel.IsExistingMatchingCard(cm.cfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function cm.act(e,tp)
	local c=aux.ExceptThisCard(e)
	if not c then return end
	rsop.SelectOC({m,0})	
	local ct,og,tc=rsop.SelectToHand(tp,cm.thfilter,tp,LOCATION_DECK,0,1,1,nil,{})
	if ct<=0 then return end
	local pos=0
	if tc:IsSummonable(true,nil,1) then pos=pos+POS_FACEUP_ATTACK end
	if tc:IsMSetable(true,nil,1) then pos=pos+POS_FACEDOWN_DEFENSE end
	if pos==0 or not rsop.SelectYesNo(tp,{m,1}) then return end
	Duel.BreakEffect()
	if Duel.SelectPosition(tp,tc,pos)==POS_FACEUP_ATTACK then
		local e1,e2=rsef.FV_LIMIT_PLAYER({c,tc,true},"sum,sp",nil,cm.limittg,{0,1},nil,rsreset.est-RESET_TOFIELD)
		e1:SetRange(LOCATION_MZONE)
		e2:SetRange(LOCATION_MZONE)
		Duel.Summon(tp,tc,true,nil,1)
	else
		Duel.MSet(tp,tc,true,nil,1)
	end
end
function cm.limittg(e,c)
	return c:IsLevelBelow(e:GetHandler():GetLevel())
end
function cm.thfilter(c)
	return c:IsAbleToHand() and c:IsSummonableCard() and c:IsLevelAbove(5)
end

