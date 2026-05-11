--【克己天临】 阿鲁摩塔赫尔
local m=14002134
local cm=_G["c"..m]
cm.named_with_Almotaher=1
function cm.initial_effect(c)
	c:EnableReviveLimit()
	local e_x=Effect.CreateEffect(c)
	e_x:SetDescription(aux.Stringid(m,0))
	e_x:SetType(EFFECT_TYPE_FIELD)
	e_x:SetCode(EFFECT_SPSUMMON_PROC)
	e_x:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e_x:SetRange(LOCATION_EXTRA)
	e_x:SetCondition(cm.XyzLevelFreeCondition(cm.ovfilter,nil,1,1))
	e_x:SetTarget(cm.XyzLevelFreeTarget(cm.ovfilter,nil,1,1))
	e_x:SetOperation(cm.XyzLevelFreeOperation(cm.ovfilter,nil,1,1))
	e_x:SetValue(SUMMON_TYPE_XYZ+SUMMON_VALUE_SELF)
	c:RegisterEffect(e_x)
	--splimit
	local e_x1=Effect.CreateEffect(c)
	e_x1:SetType(EFFECT_TYPE_SINGLE)
	e_x1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e_x1:SetCode(EFFECT_SPSUMMON_CONDITION)
	e_x1:SetValue(aux.xyzlimit)
	c:RegisterEffect(e_x1)
	--actlimit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetRange(LOCATION_MZONE)
	e1:SetTargetRange(0,1)
	e1:SetValue(1)
	e1:SetCondition(cm.actcon)
	c:RegisterEffect(e1)
	--des
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(m,1))
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(2)
	e2:SetTarget(cm.tttg)
	e2:SetOperation(cm.ttop)
	c:RegisterEffect(e2)
	cm.Death_Embrace_effect2=e2
	--Destroy and tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(m,2))
	e4:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e4:SetCode(EVENT_DESTROYED)
	e4:SetCountLimit(1,m)
	e4:SetTarget(cm.thtg)
	e4:SetOperation(cm.thop)
	c:RegisterEffect(e4)
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(m,2))
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_QUICK_O)
	e5:SetCode(EVENT_CHAINING)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCountLimit(1,m)
	e5:SetCondition(cm.thcon)
	e5:SetTarget(cm.thtg)
	e5:SetOperation(cm.thop)
	c:RegisterEffect(e5)
	--xyzlimit
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e6:SetCode(EFFECT_CANNOT_BE_XYZ_MATERIAL)
	e6:SetValue(1)
	c:RegisterEffect(e6)
	if not death_embrace_global_check then
		death_embrace_global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_CUSTOM+14002100)
		ge1:SetOperation(cm.de_count)
		Duel.RegisterEffect(ge1,0)
	end
end
function cm.de_count(e,tp,eg,ep,ev,re,r,rp)
	Duel.RegisterFlagEffect(0,14002100,RESET_PHASE+PHASE_END,0,1)
	Duel.RegisterFlagEffect(0,14002101,0,0,0)
end
function cm.Yachiyo(c)
	local mt=_G["c"..c:GetCode()]
	return mt and mt.named_with_Yachiyo
end
function cm.Almotaher(c)
	local mt=_G["c"..c:GetCode()]
	return mt and mt.named_with_Almotaher
end
function cm.ovfilter(c,xyzc)
	return cm.Almotaher(c) and c:IsLevelBelow(5)
end
function cm.XyzLevelFreeFilter(c,xyzc,f)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and (not f or f(c,xyzc))
end
function cm.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function cm.XyzLevelFreeCondition(f,gf,minct,maxct)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				if Duel.GetFlagEffect(0,14002100)<5 or Duel.GetFlagEffect(tp,m)>=1 then return false end
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
					mg=Duel.GetMatchingGroup(cm.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				if sg:IsExists(aux.MustMaterialCounterFilter,1,nil,mg) then return false end
				Duel.SetSelectedCard(sg)
				cm.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
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
					mg=Duel.GetMatchingGroup(cm.XyzLevelFreeFilter,tp,LOCATION_MZONE,0,nil,c,f)
				end
				local sg=Duel.GetMustMaterial(tp,EFFECT_MUST_BE_XMATERIAL)
				Duel.SetSelectedCard(sg)
				Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
				cm.GCheckAdditional=aux.TuneMagicianCheckAdditionalX(EFFECT_TUNE_MAGICIAN_X)
				local g=mg:SelectSubGroup(tp,cm.XyzLevelFreeGoal,true,minc,maxc,tp,c,gf)
				cm.GCheckAdditional=nil
				if g and #g>0 then
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
					if e:GetLabel()==1 or #mg==1 then
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
				Duel.RegisterFlagEffect(tp,m,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
			end
end
function cm.actcon(e)
	local a,d=Duel.GetAttacker(),Duel.GetAttackTarget()
	local tp=e:GetHandlerPlayer()
	if a and cm.Almotaher(c) and a:IsControler(tp) then
		return true
	elseif b and cm.Almotaher(c) and b:IsControler(tp) then
		return true
	end
	return false
end
function cm.tttg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g1=Duel.GetOverlayGroup(tp,1,1)
	if chk==0 then return #g1>0 and Duel.IsExistingMatchingCard(cm.Almotaher,tp,LOCATION_DECK,0,1,nil) and Duel.GetFieldGroupCount(tp,LOCATION_DECK,0)>1 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g1,1,0,0)
end
function cm.ttop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseEvent(c,EVENT_CUSTOM+14002100,e,0,0,0,0)
	local g1=Duel.GetOverlayGroup(tp,1,1)
	if #g1>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
		local g=g1:Select(tp,1,1,nil)
		if g:GetCount()>0 then
			if Duel.SendtoGrave(g,REASON_EFFECT+REASON_DESTROY)~=0 then
				Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(m,4))
				local g=Duel.SelectMatchingCard(tp,cm.Almotaher,tp,LOCATION_DECK,0,1,1,nil)
				local tc=g:GetFirst()
				if tc then
					Duel.ShuffleDeck(tp)
					Duel.MoveSequence(tc,0)
					Duel.ConfirmDecktop(tp,1)
				end
			end
		end
	end
end
function cm.thcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function cm.thfilter(c)
	return cm.Almotaher(c) and c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function cm.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetDecktopGroup(tp,1)
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,nil,1,tp,LOCATION_DECK)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,LOCATION_GRAVE)
end
function cm.thop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	Duel.RaiseEvent(c,EVENT_CUSTOM+14002100,e,0,0,0,0)
	local g=Duel.GetDecktopGroup(tp,1)
	if #g>0 and Duel.Destroy(g,REASON_EFFECT)~=0 and Duel.IsExistingMatchingCard(aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,3)) then
		Duel.BreakEffect()
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
		local g=Duel.SelectMatchingCard(tp,aux.NecroValleyFilter(cm.thfilter),tp,LOCATION_GRAVE,0,1,1,nil)
		if g:GetCount()>0 then
			Duel.SendtoHand(g,nil,REASON_EFFECT)
			Duel.ConfirmCards(1-tp,g)
		end
	end
end