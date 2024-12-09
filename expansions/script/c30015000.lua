--终墟秽泥
local m=30015000
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--summonproc or overuins
	local e0=ors.summonproc(c,5,2,1)
	--Effect 1
	local e1=ors.atkordef(c,50,2000)
	--Effect 2 
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(m,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_PHASE+PHASE_END)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCondition(cm.ccon)
	e3:SetTarget(cm.tg)
	e3:SetOperation(cm.op)
	c:RegisterEffect(e3)
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,1))
	e6:SetCategory(CATEGORY_TOHAND+CATEGORY_SUMMON)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCountLimit(2)
	e6:SetCondition(cm.con)
	e6:SetTarget(cm.tg)
	e6:SetOperation(cm.op)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
	--Effect 3 
	local e7=ors.monsterle(c)
	--all
	local e9=ors.alldrawflag(c)
end
c30015000.isoveruins=true
--Effect 2 
function cm.drt(c)
	return c:IsFacedown() and c:IsAbleToHand()
end
function cm.sumt(c)
	return c:IsSummonable(true,nil) or c:IsMSetable(true,nil)
end
function cm.set(c,tp) 
	return ors.setf(c,tp) and ors.stf(c) 
end 
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(m)
	return not eg:IsContains(e:GetHandler()) and ors.adsumcon(e) and ct<2
end
function cm.ccon(e,tp,eg,ep,ev,re,r,rp)
	local ct=e:GetHandler():GetFlagEffect(m)
	return ors.adsumcon(e) and ct<2
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,0,LOCATION_REMOVED)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local mg=Duel.GetMatchingGroup(cm.drt,tp,LOCATION_REMOVED,0,nil)
	if #mg==0 then return end
	local sg=mg:RandomSelect(tp,1)
	local tcc=sg:GetFirst() 
	if #sg==0 or tcc==nil then return false end  
	if Duel.SendtoHand(tcc,nil,REASON_EFFECT)==0 then return false end
	Duel.ConfirmCards(1-tp,tcc)
	Duel.AdjustAll()
	local sumg=Duel.GetMatchingGroup(cm.sumt,tp,LOCATION_HAND+LOCATION_MZONE,0,nil)
	local setg=Duel.GetMatchingGroup(cm.set,tp,LOCATION_HAND,0,nil,tp)
	local b1=#sumg>0
	local b2=#setg>0
	if #sumg==0 and #setg==0 then return false end
	local op=aux.SelectFromOptions(tp,{b1,1151},{b2,1153})
	if op==1 then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SUMMON)
		local sumc=sumg:Select(tp,1,1,nil):GetFirst()
		ors.sumop(e,tp,sumc)
	else
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
		local ssg=setg:Select(tp,1,1,nil)
		Duel.SSet(tp,ssg)   
	end
end