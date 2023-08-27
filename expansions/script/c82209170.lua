--炽金战兽 普卢托
local m=82209170
local cm=c82209170
function cm.initial_effect(c)
	--link summon  
	c:EnableReviveLimit()  
	aux.AddLinkProcedure(c,aux.FilterBoolFunction(Card.IsLinkAttribute,ATTRIBUTE_FIRE),2,3)
	--mat check  
	local e0=Effect.CreateEffect(c)  
	e0:SetType(EFFECT_TYPE_SINGLE)  
	e0:SetCode(EFFECT_MATERIAL_CHECK)  
	e0:SetValue(cm.valcheck)  
	c:RegisterEffect(e0)  
	--show summon words
	if not cm.summonwords then
		cm.summonwords=true
		local e114=Effect.CreateEffect(c)
		e114:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		e114:SetCode(EVENT_SPSUMMON)
		e114:SetOperation(cm.show)
		Duel.RegisterEffect(e114,tp)
	end
	--show material
	local e514=Effect.CreateEffect(c)
	e514:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)
	e514:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e514:SetCode(EVENT_SPSUMMON_SUCCESS)
	e514:SetOperation(cm.show2)
	e514:SetLabelObject(e0)
	c:RegisterEffect(e514)
	--battle indestructable
	local e1=Effect.CreateEffect(c)  
	e1:SetType(EFFECT_TYPE_SINGLE)  
	e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)  
	e1:SetValue(1)  
	c:RegisterEffect(e1)  
	--cannot remove  
	local e2=Effect.CreateEffect(c)  
	e2:SetType(EFFECT_TYPE_FIELD)  
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e2:SetCode(EFFECT_CANNOT_REMOVE)  
	e2:SetRange(LOCATION_MZONE)  
	e2:SetTargetRange(1,1)  
	e2:SetTarget(cm.rmlimit)  
	c:RegisterEffect(e2)	
	--remove  
	local e3=Effect.CreateEffect(c)  
	e3:SetDescription(aux.Stringid(m,0))  
	e3:SetCategory(CATEGORY_RECOVER)  
	e3:SetType(EFFECT_TYPE_QUICK_O)  
	e3:SetCode(EVENT_FREE_CHAIN)  
	e3:SetRange(LOCATION_MZONE)  
	e3:SetProperty(EFFECT_FLAG_PLAYER_TARGET)  
	e3:SetCountLimit(1,m)  
	e3:SetCost(cm.reccost)  
	e3:SetTarget(cm.rectg)  
	e3:SetOperation(cm.recop) 
	e3:SetLabelObject(e0)
	c:RegisterEffect(e3)  
	--release replace  
	local e4=Effect.CreateEffect(c)  
	e4:SetType(EFFECT_TYPE_FIELD)  
	e4:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE)
	e4:SetCode(EFFECT_EXTRA_RELEASE_NONSUM)  
	e4:SetRange(LOCATION_MZONE)  
	e4:SetTargetRange(0,LOCATION_MZONE)  
	e4:SetTarget(aux.TRUE)
	e4:SetCondition(cm.relcon)
	e4:SetValue(cm.relval)  
	e4:SetLabelObject(e3)
	c:RegisterEffect(e4)	
end

--mat check
function cm.valcheck(e,c)  
	local g=c:GetMaterial()  
	e:SetLabel(0)  
	if g:IsExists(Card.IsLinkRace,1,nil,RACE_MACHINE) and g:IsExists(Card.IsLinkRace,1,nil,RACE_BEAST) then  
		e:SetLabel(1)  
	end  
end  

--show material
function cm.showfilter(c)
	return c:GetOriginalCode()==m and c:GetSummonLocation()==LOCATION_EXTRA 
end
function cm.show(e,tp,eg,ep,ev,re,r,rp)
	if not eg:IsExists(cm.showfilter,1,nil) then return end
	Debug.Message("冥界的雄狮啊，驱动不熄之烈焰焚尽阻挡之敌吧！")
	Debug.Message("连接召唤！连接3，炽金战兽 普卢托！")
end
function cm.show2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsSummonType(SUMMON_TYPE_LINK) then return end
	if e:GetLabelObject():GetLabel()==1 then
		local e1=Effect.CreateEffect(c)
		e1:SetDescription(aux.Stringid(m,1))
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CANNOT_NEGATE+EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_CLIENT_HINT)
		e1:SetCode(m)
		e1:SetReset(RESET_EVENT+RESETS_STANDARD)
		c:RegisterEffect(e1)
	end
end

--cannot remove
function cm.rmlimit(e,c,tp,r)  
	return c==e:GetHandler() and r==REASON_EFFECT  
end  

--recover
function cm.recfilter(c)
	return c:IsReleasable() and c:GetAttack()>0 and (c:IsControler(tp) or c:IsFaceup())
end
function cm.reccost(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return Duel.CheckReleaseGroup(tp,cm.recfilter,1,nil) end  
	local g=Duel.SelectReleaseGroup(tp,cm.recfilter,1,1,nil)  
	e:SetLabel(g:GetFirst():GetAttack())
	Duel.Release(g,REASON_COST)  
end  
function cm.rectg(e,tp,eg,ep,ev,re,r,rp,chk)  
	if chk==0 then return true end  
	Duel.SetTargetPlayer(tp)  
	Duel.SetTargetParam(e:GetLabel())  
	Duel.SetOperationInfo(0,CATEGORY_RECOVER,nil,0,tp,e:GetLabel())  
end  
function cm.recop(e,tp,eg,ep,ev,re,r,rp)  
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)  
	Duel.Recover(p,d,REASON_EFFECT)  
end  

--release replace
function cm.relcon(e)  
	return e:GetLabelObject():GetLabelObject():GetLabel()==1
end
function cm.relval(e,re,r,rp)  
	return re==e:GetLabelObject() and bit.band(r,REASON_COST)~=0  
end  