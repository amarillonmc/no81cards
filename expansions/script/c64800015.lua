--杰作拼图7067-「太阳」
local m=64800015
local cm=_G["c"..m]
function cm.initial_effect(c)
  c:SetSPSummonOnce(m)
   local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.lkcon)
	e0:SetOperation(cm.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
--rec
	local e1=Effect.CreateEffect(c)  
	e1:SetDescription(aux.Stringid(m,0))
	e1:SetCategory(CATEGORY_RECOVER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)  
	e1:SetProperty(EFFECT_FLAG_DELAY)  
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)  
	e1:SetCountLimit(1)  
	e1:SetCondition(cm.setcon)   
	e1:SetOperation(cm.setop)  
	c:RegisterEffect(e1) 
 --draw
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetCategory(CATEGORY_DRAW)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e4:SetCode(EVENT_PHASE+PHASE_END)
	e4:SetRange(LOCATION_MZONE)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.drcon)
	e4:SetTarget(cm.drtg)
	e4:SetOperation(cm.drop)
	c:RegisterEffect(e4)
end
function cm.lkfilter1(c,lc,tp)
	 return c:IsCanBeLinkMaterial(lc) and c:IsType(TYPE_MONSTER) and c:IsType(TYPE_EFFECT)
end
function cm.lkfilter2(c,lc,tp)
	 return c:IsCanBeLinkMaterial(lc) and c:IsAbleToRemove() and c:IsType(TYPE_LINK) and c:IsRace(RACE_PLANT)
end
function cm.lvfilter(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else 
		return 1 
	end
end
function cm.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.lkfilter1,tp,LOCATION_MZONE,0,nil,c,tp)
	local mg2=Duel.GetMatchingGroup(cm.lkfilter2,tp,LOCATION_GRAVE,0,nil,c,tp)
	mg:Merge(mg2)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=2
	local maxc=2
	if ct>maxc then return false end
	return cm.lcheck(tp,sg,c,minc,ct) or mg:IsExists(cm.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc)
end
function cm.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(cm.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function cm.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=cm.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(cm.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function cm.lkop(e,tp,eg,ep,ev,re,r,rp,c)
   local c=e:GetHandler()
	local mg=Duel.GetMatchingGroup(cm.lkfilter1,tp,LOCATION_MZONE,0,nil,c,tp)
	local mg2=Duel.GetMatchingGroup(cm.lkfilter2,tp,LOCATION_GRAVE,0,nil,c,tp)
	mg:Merge(mg2)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=3
	local maxc=4
	for i=ct,maxc-1 do
		local cg=mg:Filter(cm.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if cm.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	local gg=sg:Filter(Card.IsLocation,nil,LOCATION_GRAVE)
	local og=sg:Filter(Card.IsLocation,nil,LOCATION_MZONE)
	Duel.SendtoGrave(og,REASON_MATERIAL+REASON_LINK)
	Duel.Remove(gg,POS_FACEUP,REASON_MATERIAL+REASON_LINK)
end

function cm.setcon(e,tp,eg,ep,ev,re,r,rp)  
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)  
end  
function cm.setop(e,tp,eg,ep,ev,re,r,rp)  
local ct=e:GetHandler():GetMaterial():FilterCount(Card.IsPreviousLocation,nil,LOCATION_ONFIELD)
	 Duel.Recover(tp,1500*ct,REASON_EFFECT)  
end  

function cm.drcon(e,tp,eg,ep,ev,re,r,rp)
	 return Duel.GetLP(tp)>Duel.GetLP(1-tp)
end
function cm.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function cm.drop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Draw(tp,1,REASON_EFFECT)
end





