--天花乱漫-春花刃椿
local m=14001216
local cm=_G["c"..m]
cm.named_with_Blossom_Blade=1
function cm.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,11,3)
	c:EnableReviveLimit()
	--xyz summon
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(m,0))
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(cm.XyzLevelFreeCondition(cm.BBfilter,nil,2,2))
	e0:SetTarget(cm.XyzLevelFreeTarget(cm.BBfilter,nil,2,2))
	e0:SetOperation(cm.XyzLevelFreeOperation(cm.BBfilter,nil,2,2))
	e0:SetValue(SUMMON_TYPE_XYZ+SUMMON_VALUE_SELF)
	c:RegisterEffect(e0)
	--summon success
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(cm.sumcon)
	e1:SetTarget(cm.sumtg)
	e1:SetOperation(cm.sumsuc)
	c:RegisterEffect(e1)
	cm.selfsummon_effect=e1
	--multi attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_EXTRA_ATTACK_MONSTER)
	e2:SetValue(cm.raval)
	c:RegisterEffect(e2)
	--ind
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e3:SetCode(EFFECT_CANNOT_ACTIVATE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(0,1)
	e3:SetCondition(cm.indcon)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function cm.BB(c)
	local m=_G["c"..c:GetCode()]
	return m and m.named_with_Blossom_Blade
end
function cm.BBfilter(c,xyzc)
	return cm.BB(c)
end
function cm.XyzLevelFreeFilter(c,xyzc,f)
	return c:IsFaceup() and c:IsCanBeXyzMaterial(xyzc) and (not f or f(c,xyzc))
end
function cm.XyzLevelFreeGoal(g,tp,xyzc,gf)
	return (not gf or gf(g)) and Duel.GetLocationCountFromEx(tp,tp,g,xyzc)>0
end
function cm.cfilter(c)
	return c:IsFaceup() and c:IsCode(14001208)
end
function cm.XyzLevelFreeCondition(f,gf,minct,maxct)
	return  function(e,c,og,min,max)
				if c==nil then return true end
				if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
				local tp=c:GetControler()
				if not Duel.IsExistingMatchingCard(cm.cfilter,tp,LOCATION_MZONE,0,1,nil) then return false end
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
				local sg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
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
				local sg=aux.GetMustMaterialGroup(tp,EFFECT_MUST_BE_XMATERIAL)
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
function cm.sumcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_VALUE_SELF)
end
function cm.tgfilter(c)
	return cm.BB(c) and c:IsAbleToGrave()
end
function cm.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) end
end
function cm.sumsuc(e,tp,eg,ep,ev,re,r,rp)
	if Duel.IsExistingMatchingCard(cm.tgfilter,tp,LOCATION_DECK,0,1,nil) and Duel.SelectYesNo(tp,aux.Stringid(m,1)) then
		Duel.Hint(HINT_CARD,0,m)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		local g=Duel.SelectMatchingCard(tp,cm.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
		if #g>0 then
			Duel.SendtoGrave(g,REASON_EFFECT)
		end
	end
end
function cm.raval(e,c)
	return e:GetHandler():GetOverlayCount()
end
function cm.actfilter(c,tp)
	return c:IsFaceup() and c:IsRace(RACE_PLANT) and c:IsControler(tp)
end
function cm.indcon(e)
	local tp=e:GetHandlerPlayer()
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return (a and cm.actfilter(a,tp)) or (d and cm.actfilter(d,tp))
end