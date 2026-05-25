-- 无法翻过的页
local s,id,o=GetID()
function s.initial_effect(c)
	c:EnableCounterPermit(0x1)
  --fusion material
	c:EnableReviveLimit()
	aux.AddFusionProcFunRep(c,s.ffilter,2,true) 
	--aux.AddContactFusionProcedure(c,Card.IsAbleToGraveAsCost,LOCATION_MZONE,0,Duel.SendtoGrave,REASON_COST)

	--①融合召唤成功时
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(id,0))
	e1:SetCategory(CATEGORY_COUNTER)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetProperty(EFFECT_FLAG_DELAY)
	e1:SetCondition(s.countercon)
	e1:SetOperation(s.counterop)
	c:RegisterEffect(e1)
	--②对方效果发动时
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(id,1))
	e2:SetType(EFFECT_TYPE_QUICK_O)
	e2:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DAMAGE_CAL)
	e2:SetCode(EVENT_CHAINING)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(s.chcon)
	e2:SetCost(s.chcost)
	e2:SetTarget(s.chtg)
	e2:SetOperation(s.chop)
	c:RegisterEffect(e2)
end
function s.ffilter(c,fc,sub,mg,sg)
	return not sg or sg:FilterCount(aux.TRUE,c)==0
		or not sg:IsExists(Card.IsFusionCode,1,c,c:GetFusionCode())
end 

function s.countercon(e,tp,eg,ep,ev,re,r,rp)
	local mg= e:GetHandler():GetMaterial()
	if not mg then return false end
	return e:GetHandler():IsSummonType(SUMMON_TYPE_FUSION) 
end

function s.counterop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	if not mg then return end
	local sum=0
	for tc in aux.Next(mg) do
		if tc:IsType(TYPE_MONSTER) then
			local lv=tc:GetLevel()
			if lv>0 then sum=sum+lv end
		end
	end
	if sum>0 then
		c:AddCounter(0x1,sum)
	end
end

function s.chcost(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	local ct=c:GetCounter(0x1)
	local need=math.ceil(ct/2)
	if chk==0 then return ct>0 and need>0 and c:IsCanRemoveCounter(tp,0x1,need,REASON_COST) end
	c:RemoveCounter(tp,0x1,need,REASON_COST)
	e:SetLabel(need)
end
function s.chcon(e,tp,eg,ep,ev,re,r,rp)
	return rp==1-tp
end
function s.chtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	local need = e:GetLabel()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,tp,need*500)
end

function s.chop(e,tp,eg,ep,ev,re,r,rp)
	local need = e:GetLabel()
	if Duel.Damage(tp,need*500,REASON_EFFECT)<=0 then return end
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if re:IsActiveType(TYPE_MONSTER) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,s.repop_mon)
	elseif re:IsActiveType(TYPE_SPELL) or re:IsActiveType(TYPE_TRAP) then
		local g=Group.CreateGroup()
		Duel.ChangeTargetCard(ev,g)
		Duel.ChangeChainOperation(ev,s.repop_spe)
	end
end

function s.repop_mon(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,0,LOCATION_HAND)
	if g:GetCount()>0 then
		local sg=g:RandomSelect(tp,1)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end
function s.repop_spe(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetFieldGroup(1-tp,0,LOCATION_GRAVE)
	if g:GetCount()>0 then
		local sg=g:Select(1-tp,1,1,nil)
		Duel.Remove(sg,POS_FACEUP,REASON_EFFECT)
	end
end