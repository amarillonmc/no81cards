--归墟仲裁·沌涡
local m=30015100
local cm=_G["c"..m]
if not overuins then dofile("expansions/script/c30015500.lua") end
function cm.initial_effect(c)
	--not Special Summon
	--summonproc or overuins
	local e0=ors.summonproc(c,10,6,3)
	--Effect 1
	local e1=ors.atkordef(c,150,2500)
	local e7=Effect.CreateEffect(c)
	e7:SetType(EFFECT_TYPE_SINGLE)
	e7:SetCode(EFFECT_CANNOT_DISABLE_SUMMON)
	e7:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	c:RegisterEffect(e7)
	--Effect 2 
	local e6=Effect.CreateEffect(c)
	e6:SetDescription(aux.Stringid(m,0))
	e6:SetCategory(CATEGORY_REMOVE)
	e6:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e6:SetCode(EVENT_SPSUMMON_SUCCESS)
	e6:SetRange(LOCATION_MZONE)
	e6:SetCondition(cm.con)
	e6:SetTarget(cm.tg)
	e6:SetOperation(cm.op)
	c:RegisterEffect(e6)
	local e7=e6:Clone()
	e7:SetCode(EVENT_SUMMON_SUCCESS)
	c:RegisterEffect(e7)
	--Effect 3 
	local e11=ors.monsterleup(c)
	--all
	local e9=ors.alldrawflag(c)
end
c30015100.isoveruins=true
--all
--Effect 2 
function cm.df(c,rty) 
	return c:IsType(rty) 
end   
function cm.con(e,tp,eg,ep,ev,re,r,rp)
	return not eg:IsContains(e:GetHandler()) and ors.adsumcon(e)
end
function cm.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,nil,1,1-tp,LOCATION_DECK+LOCATION_EXTRA)
end
function cm.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local xg=Duel.GetFieldGroup(tp,0,LOCATION_EXTRA)
	local dg=Duel.GetFieldGroup(tp,0,LOCATION_DECK)
	if #xg==0 and #dg==0 then return false end
	local xc=nil
	local dc=nil
	if #dg>0 then
		dc=Duel.GetDecktopGroup(1-tp,1):GetFirst()
	end
	local b1= #xg>0 and xg:FilterCount(Card.IsAbleToRemove,nil,tp,POS_FACEDOWN)>0
	local b2= dc~=nil and dc and dc:IsAbleToRemove(tp,POS_FACEDOWN)
	local op=aux.SelectFromOptions(tp,{b1,aux.Stringid(m,1)},{b2,aux.Stringid(m,2)})
	if op==1 then
		xc=xg:GetMaxGroup(Card.GetSequence):GetFirst()
		Duel.ConfirmCards(tp,xc)
		Duel.DisableShuffleCheck()
		if Duel.Remove(xc,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
		Duel.ShuffleExtra(1-tp)
		if c:IsFacedown() or c:GetLocation()~=LOCATION_MZONE then return false end
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetValue(500)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD+RESET_DISABLE)
		c:RegisterEffect(e1)
	else
		Duel.ConfirmDecktop(1-tp,1)
		Duel.DisableShuffleCheck()
		if Duel.Remove(dc,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
		local rtype=bit.band(dc:GetType(),0x7)
		local rg=Duel.GetMatchingGroup(cm.df,tp,0,LOCATION_ONFIELD,nil,rtype)
		if #rg==0 then return false end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local xxc=rg:FilterSelect(tp,cm.df,1,1,nil,rtype):GetFirst()
		if xxc:IsFacedown() then Duel.ConfirmCards(tp,xxc) end
		if xxc==nil or Duel.Remove(xxc,POS_FACEDOWN,REASON_EFFECT)==0 then return false end
	end
end
--Effect 3 
