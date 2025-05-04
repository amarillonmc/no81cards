--宿星之斗争军势
--23.08.04
local cm,m=GetID()
function cm.initial_effect(c)
	--xyz summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	e0:SetCondition(aux.XyzCondition(cm.ovfilter,10,1,99))
	e0:SetTarget(aux.XyzTarget(cm.ovfilter,10,1,99))
	e0:SetOperation(aux.XyzOperation(cm.ovfilter,10,1,99))
	e0:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e0)
	--aux.AddXyzProcedure(c,nil,10,2,cm.ovfilter,1165,99,cm.xyzop2)
	c:EnableReviveLimit()
	--xyz in battle end
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(1165)
	e0:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e0:SetCode(EVENT_PHASE+PHASE_BATTLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_GRAVE)
	e0:SetCondition(cm.xyzcon)
	e0:SetOperation(cm.xyzop)
	--c:RegisterEffect(e0)
	--activate from hand
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_TRAP_ACT_IN_HAND)
	e1:SetDescription(aux.Stringid(m,3))
	e1:SetRange(LOCATION_MZONE)
	e1:SetTarget(aux.TargetEqualFunction(Card.GetType,0x4))
	e1:SetTargetRange(LOCATION_HAND,LOCATION_HAND)
	c:RegisterEffect(e1)
	--summon proc
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,0))
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SUMMON_PROC)
	e2:SetTargetRange(LOCATION_HAND,0)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCondition(cm.otcon)
	e2:SetTarget(cm.ottg)
	e2:SetOperation(cm.otop)
	e2:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e2)
	local e3=e2:Clone()
	e3:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e3)
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,1))
	e4:SetType(EFFECT_TYPE_FIELD)
	e4:SetCode(EFFECT_SUMMON_PROC)
	e4:SetTargetRange(0,LOCATION_HAND)
	e4:SetRange(LOCATION_GRAVE)
	e4:SetCondition(cm.otcon2)
	e4:SetTarget(cm.ottg)
	e4:SetOperation(cm.otop2)
	e4:SetValue(SUMMON_TYPE_ADVANCE)
	c:RegisterEffect(e4)
	local e5=e4:Clone()
	e5:SetCode(EFFECT_SET_PROC)
	c:RegisterEffect(e5)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetCode(m)
	e6:SetRange(LOCATION_EXTRA+LOCATION_GRAVE)
	c:RegisterEffect(e6)
	--to grave
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetCode(EVENT_RELEASE)
	e2:SetOperation(cm.regop)
	c:RegisterEffect(e2)
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_GRAVE+LOCATION_REMOVED)
	e1:SetCountLimit(1)
	e1:SetCondition(cm.adcon)
	e1:SetTarget(cm.adtg)
	e1:SetOperation(cm.adop)
	c:RegisterEffect(e1)
	local e4=e1:Clone()
	e4:SetProperty(EFFECT_FLAG_BOTH_SIDE)
	e4:SetCondition(cm.adcon2)
	c:RegisterEffect(e4)
	if not cm.global_check then
		cm.global_check=true
		local ge1=Effect.GlobalEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(cm.checkop)
		Duel.RegisterEffect(ge1,0)
		cm[0]=nil
		cm[1]=nil
		local _IsExistingMatchingCard=Duel.IsExistingMatchingCard
		local _SelectMatchingCard=Duel.SelectMatchingCard
		local _GetMatchingGroup=Duel.GetMatchingGroup
		local _IsXyzSummonable=Card.IsXyzSummonable
		local _IsSpecialSummonable=Card.IsSpecialSummonable
		function Duel.GetMatchingGroup(f,p,s,o,nc,...)
			local s1=s&LOCATION_EXTRA>0 and LOCATION_GRAVE or 0
			local o1=o&LOCATION_EXTRA>0 and LOCATION_GRAVE or 0
			cm[0]=false
			local g=_GetMatchingGroup(f,p,s1,o1,nc,...):Filter(function(c) return c:GetOriginalCode()==m end,nil)
			if cm[0] and #g>0 then
				cm[0]=false
				local sg=_GetMatchingGroup(f,p,s,o,nc,...)
				return sg+g
			end
			cm[0]=false
			local sg=_GetMatchingGroup(f,p,s,o,nc,...)
			return sg
		end
		function Card.IsXyzSummonable(c,mg,min,max,...)
			cm[0]=true
			return _IsXyzSummonable(c,mg,min,max,...)
		end
		function Card.IsSpecialSummonable(c,sumtype,...)
			if sumtype==SUMMON_TYPE_XYZ then
				return c:IsXyzSummonable(nil)
			end
			return _IsSpecialSummonable(c,sumtype,...)
		end
		function Duel.IsExistingMatchingCard(f,p,s,o,ct,nc,...)
			local g=Duel.GetMatchingGroup(f,p,s,o,nc,...)
			return #g>=ct
		end
		function Duel.SelectMatchingCard(sp,f,p,s,o,min,max,nc,...)
			local g=Duel.GetMatchingGroup(f,p,s,o,nc,...)
			return g:Select(sp,min,max,nc)
		end
	end
end
function cm.regop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	c:RegisterFlagEffect(m,RESET_EVENT+0x1f20000+RESET_PHASE+PHASE_END,0,1)
end
function cm.adcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0
end
function cm.adcon2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(m)>0 and tp~=e:GetHandlerPlayer()
end
function cm.adtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsAbleToDeck,nil)
	if chk==0 then return #hg>0 and Duel.IsPlayerCanDraw(tp,#hg) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,hg,#hg,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,#hg)
end
function cm.adop(e,tp,eg,ep,ev,re,r,rp)
	local hg=Duel.GetFieldGroup(tp,LOCATION_HAND,0):Filter(Card.IsAbleToDeck,nil)
	local ct=Duel.SendtoDeck(hg,nil,2,REASON_EFFECT)
	if ct>0 then
		if Duel.GetOperatedGroup():IsExists(function(c) return c:IsLocation(LOCATION_DECK) and c:IsControler(tp) end,1,nil) then Duel.ShuffleDeck(tp) end
		Duel.Draw(tp,ct,REASON_EFFECT)
	end
end
function cm.extfilter(c)
	return c:IsHasEffect(m)
end
function cm.checkop(e,tp,eg,ep,ev,re,r,rp)
	local ac,bc=Duel.GetBattleMonster(0)
	if ac then
		ac:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
	if bc then
		bc:RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD,0,1)
	end
end
function cm.XyzConditionAlter(f,lv,minc,maxc,alterf,alterdesc,alterop)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				if c:IsLocation(LOCATION_GRAVE) then
					return Duel.GetCurrentPhase()==PHASE_BATTLE and (not min or min<=1) and mg:IsExists(Auxiliary.XyzAlterFilter,1,nil,alterf,c,e,tp,alterop)
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
					if minc>maxc then return false end
				end
				return Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
			end
end
function cm.XyzTargetAlter(f,lv,minc,maxc,alterf,alterdesc,alterop)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minc
				local maxc=maxc
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og
				else
					mg=Duel.GetFieldGroup(tp,LOCATION_MZONE,0)
				end
				local altg=mg:Filter(Auxiliary.XyzAlterFilter,nil,alterf,c,e,tp,alterop)
				local b1=not c:IsLocation(LOCATION_GRAVE) and Duel.CheckXyzMaterial(c,f,lv,minc,maxc,og)
				local b2=c:IsLocation(LOCATION_GRAVE) and Duel.GetCurrentPhase()==PHASE_BATTLE and (not min or min<=1) and #altg>0
				local g=nil
				local cancel=Duel.IsSummonCancelable()
				if b2 and (not b1 or Duel.SelectYesNo(tp,alterdesc)) then
					e:SetLabel(1)
					Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
					local tc=altg:SelectUnselect(nil,tp,false,cancel,1,1)
					if tc then
						g=Group.FromCards(tc)
						if alterop then alterop(e,tp,1,tc) end
					end
				else
					e:SetLabel(0)
					g=Duel.SelectXyzMaterial(tp,c,f,lv,minc,maxc,og)
				end
				if g then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.ovfilter(c)
	return c:IsFaceup() and c:GetFlagEffect(m)>0
end
function cm.xyzop2(e,tp,chk)
	if chk==0 then return true end
end
function cm.xyzcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSpecialSummonable(SUMMON_TYPE_XYZ) and e:GetHandler():GetFlagEffect(m)==0
end
function cm.xyzop(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(m,RESET_EVENT+RESETS_STANDARD+RESET_PHASE+PHASE_BATTLE,0,1)
	if Duel.SelectYesNo(tp,aux.Stringid(m,2)) then
		Duel.SpecialSummonRule(tp,e:GetHandler(),SUMMON_TYPE_XYZ)
	end
end
function cm.mfilter(c)
	return c:IsPublic() and c:IsType(TYPE_MONSTER)
end
function cm.otcon(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_HAND,0,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(function(e,c) return cm.mfilter(c) and c~=e:GetHandler() end)
	e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	c:RegisterEffect(e1,true)
	local e2=e1:Clone()
	e2:SetTargetRange(LOCATION_EXTRA,0)
	e2:SetTarget(function(e,c) return c==e:GetOwner() end)
	local chk1=Duel.CheckTribute(c,1,1,mg)
	e1:Reset()
	c:RegisterEffect(e2,true)
	local chk2=Duel.CheckTribute(c,1,1,Group.FromCards(e:GetHandler()))
	e2:Reset()
	return minc<=2 and Duel.GetMZoneCount(tp)>0 and chk1 and chk2
end
function cm.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi<=2 and ma>=2
end
function cm.otop(e,tp,eg,ep,ev,re,r,rp,c)
	local mg=Duel.GetMatchingGroup(cm.mfilter,tp,LOCATION_HAND,0,nil)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_ADD_EXTRA_TRIBUTE)
	e1:SetTargetRange(LOCATION_HAND,0)
	e1:SetTarget(function(e,c) return cm.mfilter(c) and c~=e:GetHandler() end)
	e1:SetValue(POS_FACEUP_ATTACK+POS_FACEDOWN_DEFENSE)
	c:RegisterEffect(e1,true)
	local g=Duel.SelectTribute(tp,c,1,1,mg)
	e1:Reset()
	g:AddCard(e:GetHandler())
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_SUMMON+REASON_MATERIAL+REASON_RELEASE)
end
function cm.otcon2(e,c,minc)
	if c==nil then return true end
	local tp=c:GetControler()
	local ec=e:GetHandler()
	return minc<=2 and ec:IsAbleToDeckOrExtraAsCost() and Duel.CheckTribute(c,1)
end
function cm.ottg(e,c)
	local mi,ma=c:GetTributeRequirement()
	return mi<=2 and ma>=2
end
function cm.otop2(e,tp,eg,ep,ev,re,r,rp,c)
	local ec=e:GetHandler()
	local g=Duel.SelectTribute(tp,c,1,1)
	g:AddCard(ec)
	c:SetMaterial(g)
	g:RemoveCard(ec)
	Duel.SendtoDeck(ec,nil,2,REASON_SUMMON+REASON_MATERIAL+REASON_COST)
	Duel.Release(g,REASON_SUMMON+REASON_MATERIAL)
end