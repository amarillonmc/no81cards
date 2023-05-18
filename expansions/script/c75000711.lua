--火焰纹章if·马库斯
local m=75000711
local cm=_G["c"..m]
function cm.initial_effect(c)
	--xyz summon rule
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(1165)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_SPSUMMON_PROC)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetRange(LOCATION_EXTRA)
	e1:SetCondition(cm.XyzLevelFreeCondition(cm.f,cm.fs,2,2))
	e1:SetTarget(cm.XyzLevelFreeTarget(cm.f,cm.fs,2,2))
	e1:SetOperation(cm.XyzLevelFreeOperation(cm.f,cm.fs,2,2))
	e1:SetValue(SUMMON_TYPE_XYZ)
	c:RegisterEffect(e1)
	--Effect 1
	local e54=Effect.CreateEffect(c)
	e54:SetType(EFFECT_TYPE_SINGLE)
	e54:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e54:SetRange(LOCATION_MZONE)
	e54:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e54:SetValue(1)
	c:RegisterEffect(e54)
	local e04=Effect.CreateEffect(c)
	e04:SetType(EFFECT_TYPE_SINGLE)
	e04:SetCode(EFFECT_CHANGE_BATTLE_DAMAGE)
	e04:SetCondition(cm.damcon)
	e04:SetValue(aux.ChangeBattleDamage(1,DOUBLE_DAMAGE))
	c:RegisterEffect(e04)
	--Effect 2
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,0))
	e4:SetCategory(CATEGORY_NEGATE)
	e4:SetType(EFFECT_TYPE_QUICK_O)
	e4:SetCode(EVENT_CHAINING)
	e4:SetRange(LOCATION_MZONE)
	e4:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e4:SetCountLimit(1)
	e4:SetCondition(cm.discon)
	e4:SetTarget(cm.distg)
	e4:SetOperation(cm.disop)
	c:RegisterEffect(e4)
end
--
--xyz summon rule
function cm.f(c,xyzc)
	local tp=xyzc:GetControler()
	local b1=c:IsControler(tp) and c:IsXyzLevel(xyzc,8) 
	local b2=c:IsControler(1-tp) and c:GetOwner()==tp
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and (b1 or b2)
end
function cm.fs(g,tp) 
	return g:FilterCount(Card.IsControler,nil,1-tp)<=1
end
function cm.XyzLevelFreeFilter(c,xyzc,f)
	return (not c:IsOnField() or c:IsFaceup()) and c:IsCanBeXyzMaterial(xyzc) and (not f or f(c,xyzc))
end
function cm.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g,tp)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function cm.TuneMagicianFilter(c,e)
	local f=e:GetValue()
	return f(e,c)
end
function cm.GetMustMaterialGroup(tp,code)
	local g=Group.CreateGroup()
	local ce={Duel.IsPlayerAffectedByEffect(tp,code)}
	for _,te in ipairs(ce) do
		local tc=te:GetHandler()
		if tc then g:AddCard(tc) end
	end
	return g
end
function cm.MustMaterialCounterFilter(c,g)
	return not g:IsContains(c)
end
function cm.TuneMagicianCheckX(c,sg,ecode)
	local eset={c:IsHasEffect(ecode)}
	for _,te in pairs(eset) do
		if sg:IsExists(cm.TuneMagicianFilter,1,c,te) then return true end
	end
	return false
end
function cm.TuneMagicianCheckAdditionalX(ecode)
	return  function(g)
				return not g:IsExists(cm.TuneMagicianCheckX,1,nil,g,ecode)
			end
end
function cm.XyzLevelFreeCondition(f,gf,minct,maxct)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				local minc=minct
				local maxc=maxct
				if min then
					minc=math.max(minc,min)
					maxc=math.min(maxc,max)
				end
				if maxc<minc then return false end
				local mg=nil
				if og then
					mg=og:Filter(cm.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(cm.XyzLevelFreeFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,f)
				end
				local sg=cm.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(cm.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				cm.GCheckAdditional=cm.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local res=mg:CheckSubGroup(cm.XyzLevelFreeGoal,minc,maxc,tp,c,gf)
				cm.GCheckAdditional=nil
				return res
			end
end
function cm.XyzLevelFreeTarget(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,chk,c,og,min,max)
				if og and not min then
					return true
				end
				local minc=minct
				local maxc=maxct
				if min then
					if min>minc then minc=min end
					if max<maxc then maxc=max end
				end
				local mg=nil
				if og then
					mg=og:Filter(cm.XyzLevelFreeFilter,nil,c,f)
				else
					mg=Duel.GetMatchingGroup(cm.XyzLevelFreeFilter,tp,LOCATION_MZONE,LOCATION_MZONE,nil,c,f)
				end
				local sg=cm.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				local cancel=Duel.IsSummonCancelable()
				cm.GCheckAdditional=cm.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,cm.XyzLevelFreeGoal,cancel,minc,maxc,tp,c,gf)
				cm.GCheckAdditional=nil
				if g and g:GetCount()>0 then
					g:KeepAlive()
					e:SetLabelObject(g)
					return true
				else return false end
			end
end
function cm.XyzLevelFreeOperation(f,gf,minct,maxct)
	return  function(e,tp,eg,ep,ev,re,r,rp,c,og,min,max)
				if og and not min then
					local sg=Group.CreateGroup()
					local tc=og:GetFirst()
					while tc do
						local sg1=tc:GetOverlayGroup()
						sg:Merge(sg1)
						tc=og:GetNext()
					end
					Duel.SendtoGrave(sg,REASON_RULE)
					c:SetMaterial(og)
					Duel.Overlay(c,og)
				else
					local mg=e:GetLabelObject()
					if e:GetLabel()==1 then
						local mg2=mg:GetFirst():GetOverlayGroup()
						if mg2:GetCount()~=0 then
							Duel.Overlay(c,mg2)
						end
					else
						local sg=Group.CreateGroup()
						local tc=mg:GetFirst()
						while tc do
							local sg1=tc:GetOverlayGroup()
							sg:Merge(sg1)
							tc=mg:GetNext()
						end
						Duel.SendtoGrave(sg,REASON_RULE)
					end
					c:SetMaterial(mg)
					Duel.Overlay(c,mg)
					mg:DeleteGroup()
				end
			end
end
--Effect 1
function cm.damcon(e)
	local tp=e:GetHandlerPlayer()
	return Duel.GetLP(1-tp)>=4000
end
--Effect 2
function cm.discon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsStatus(STATUS_BATTLE_DESTROYED) then return false end
	if not re:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then return false end
	local tg=Duel.GetChainInfo(ev,CHAININFO_TARGET_CARDS)
	local b1=Duel.IsChainNegatable(ev) and rp==1-tp
	local b2=tg and tg:IsExists(Card.IsLocation,1,nil,LOCATION_ONFIELD) 
	return b1 and b2
end
function cm.distg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DISABLE,eg,1,0,0)
end
function cm.disop(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
end
--Effect 3 
--Effect 4 
--Effect 5  
