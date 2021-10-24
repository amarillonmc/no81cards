--魔偶甜点 可可玛卡龙
function c10700448.initial_effect(c)
	c:EnableReviveLimit()
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(c10700448.lkcon)
	e1:SetOperation(c10700448.lkop)
	e1:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e1)	
	--search
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(10700448,0))
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetProperty(EFFECT_FLAG_DELAY)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCountLimit(1,10700448)
	e2:SetCondition(c10700448.stcon)
	e2:SetTarget(c10700448.sttg)
	e2:SetOperation(c10700448.stop)
	c:RegisterEffect(e2)
	--Destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(10700448,1))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_START)
	e3:SetCountLimit(1,10700449)
	e3:SetCondition(c10700448.descon)
	e3:SetTarget(c10700448.destg)
	e3:SetOperation(c10700448.desop)
	c:RegisterEffect(e3)
	local e5=Effect.CreateEffect(c)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCategory(CATEGORY_DESTROY)
	e5:SetCode(EVENT_FREE_CHAIN)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,10700449)
	e5:SetCondition(c10700448.descon2)
	e5:SetTarget(c10700448.destg)
	e5:SetOperation(c10700448.desop)
	c:RegisterEffect(e5)
end
--link
function c10700448.lkfilter(c,lc,tp)
	if not (c:IsFaceup() and c:IsSetCard(0x71)) then
		return false
	else
		if c:IsType(TYPE_MONSTER) then
			return c:IsCanBeLinkMaterial(lc)
		else
			return true
		end
	end
end
function c10700448.lvfilter(c)
	if c:IsType(TYPE_LINK) and c:GetLink()>1 then
		return 1+0x10000*c:GetLink()
	else 
		return 1
	end
end
function c10700448.lcheck(tp,sg,lc,minc,ct)
	return ct>=minc and sg:CheckWithSumEqual(c10700448.lvfilter,lc:GetLink(),ct,ct) and Duel.GetLocationCountFromEx(tp,tp,sg,lc)>0
end
function c10700448.lkchenk(c,tp,sg,mg,lc,ct,minc,maxc)
	sg:AddCard(c)
	ct=ct+1
	local res=c10700448.lcheck(tp,sg,lc,minc,ct) or (ct<maxc and mg:IsExists(c10700448.lkchenk,1,sg,tp,sg,mg,lc,ct,minc,maxc))
	sg:RemoveCard(c)
	ct=ct-1
	return res
end
function c10700448.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(c10700448.lkfilter,tp,LOCATION_ONFIELD,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		local pc=pe:GetHandler()
		if not mg:IsContains(pc) then return false end
		sg:AddCard(pc)
	end
	local ct=sg:GetCount()
	local minc=2
	local maxc=99
	if ct>maxc then return false end
	return c10700448.lcheck(tp,sg,c,minc,ct) or mg:IsExists(c10700448.lkchenk,1,nil,tp,sg,mg,c,ct,minc,maxc)
end
function c10700448.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(c10700448.lkfilter,tp,LOCATION_ONFIELD,0,nil,c,tp)
	local sg=Group.CreateGroup()
	for i,pe in ipairs({Duel.IsPlayerAffectedByEffect(tp,EFFECT_MUST_BE_LMATERIAL)}) do
		sg:AddCard(pe:GetHandler())
	end
	local ct=sg:GetCount()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
	sg:Select(tp,ct,ct,nil)
	local minc=2
	local maxc=99
	for i=ct,maxc-1 do
		local cg=mg:Filter(c10700448.lkchenk,sg,tp,sg,mg,c,i,minc,maxc)
		if cg:GetCount()==0 then break end
		local minct=1
		if c10700448.lcheck(tp,sg,c,minc,i) then
			if not Duel.SelectYesNo(tp,210) then break end
			minct=0
		end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_LMATERIAL)
		local g=cg:Select(tp,minct,1,nil)
		if g:GetCount()==0 then break end
		sg:Merge(g)
	end
	c:SetMaterial(sg)
	Duel.SendtoGrave(sg,REASON_MATERIAL+REASON_LINK)
end
--set
function c10700448.stcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c10700448.stfilter(c)  
	return c:IsSetCard(0x71) and c:IsSSetable() and c:IsType(TYPE_SPELL+TYPE_TRAP)  
end  
function c10700448.sttg(e,tp,eg,ep,ev,re,r,rp,chk) 
	local tp=e:GetHandler():GetControler() 
	if chk==0 then return Duel.IsExistingMatchingCard(c10700448.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,nil) end  
end  
function c10700448.stop(e,tp,eg,ep,ev,re,r,rp)  
	local tp=e:GetHandler():GetControler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)  
	local g=Duel.SelectMatchingCard(tp,c10700448.stfilter,tp,LOCATION_DECK+LOCATION_GRAVE,0,1,1,nil) 
	local tc=g:GetFirst()
	if g:GetCount()~=0 and Duel.SSet(tp,g)>0 then   
		  if tc:IsType(TYPE_QUICKPLAY) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetCode(EFFECT_QP_ACT_IN_SET_TURN)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
		  end
		  if tc:IsType(TYPE_TRAP) then
			 local e1=Effect.CreateEffect(e:GetHandler())
			 e1:SetType(EFFECT_TYPE_SINGLE)
			 e1:SetCode(EFFECT_TRAP_ACT_IN_SET_TURN)
			 e1:SetProperty(EFFECT_FLAG_SET_AVAILABLE)
			 e1:SetReset(RESET_EVENT+RESETS_STANDARD)
			 tc:RegisterEffect(e1)
		 end
	end
end
--get x y label
function c10700448.xylabel(c,tp)
	local x=c:GetSequence()
	local y=0
	if c:GetControler()==tp then
		if c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_PZONE) then y=0
		elseif c:IsLocation(LOCATION_MZONE) and x<=4 then y=1
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=1,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=3,2
		else x,y=-1,-5 end
	elseif c:GetControler()==1-tp then
		if c:IsLocation(LOCATION_SZONE) or c:IsLocation(LOCATION_PZONE) then x,y=4-x,4
		elseif c:IsLocation(LOCATION_MZONE) and x<=4 then x,y=4-x,3
		elseif c:IsLocation(LOCATION_MZONE) and x==5 then x,y=3,2
		elseif c:IsLocation(LOCATION_MZONE) and x==6 then x,y=1,2
		else x,y=5,9 end
	end
	return x,y
end
--gradient modification
function c10700448.gradient(y,x)
	if y>0 and x==0 then return 1000 end
	if y<0 and x==0 then return 1100 end
	if y>0 and x~=0 then return y/x end
	if y<0 and x~=0 then return y/x+100 end
	if y==0 and x>0 then return 0 end
	if y==0 and x<0 then return 100 end
	return 65536
end
--draw lines with gradients k
function c10700448.line(tc,c,tp,...)
	local x1,y1=c10700448.xylabel(c,tp)
	local x2,y2=c10700448.xylabel(tc,tp)
	for _,k in ipairs({...}) do
		if c10700448.gradient(y2-y1,x2-x1)==k then return true end
	end
	return false
end
--Link Marker as example
-- ↙ 101
-- ↓ 1100
-- ↘ 99
-- ← 100
-- → 0
-- ↖ -1
-- ↑ 1000
-- ↗ 1
function c10700448.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function c10700448.descon2(e)
	return Duel.IsExistingMatchingCard(Card.IsFaceup,0,LOCATION_FZONE,LOCATION_FZONE,1,nil)
end
function c10700448.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c10700448.line,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp,1,101,1000,1100)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,#g,0,0)
end
function c10700448.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(nil,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil)
	for tc in aux.Next(g) do
		local x1,y1=c10700448.xylabel(c,tp)
		local x2,y2=c10700448.xylabel(tc,tp)
	end
	local g=Duel.GetMatchingGroup(c10700448.line,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,nil,c,tp,1,101,1000,1100)
	if #g>0 then
		Duel.Destroy(g,REASON_EFFECT)
	end
end