function c10105409.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	--Atk
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c10105409.tg)
	e2:SetValue(800)
	c:RegisterEffect(e2)
    	 --draw
    local e3=Effect.CreateEffect(c)
    e3:SetDescription(aux.Stringid(10105409,0))
    e3:SetCategory(CATEGORY_DRAW)
    e3:SetType(EFFECT_TYPE_IGNITION)
    e3:SetRange(LOCATION_FZONE)  -- 场地魔法区域
    e3:SetCountLimit(1)
    e3:SetTarget(c10105409.drtg)
    e3:SetOperation(c10105409.drop)
    c:RegisterEffect(e3)
    	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(10105409,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_BATTLE_DESTROYED)
	e4:SetRange(LOCATION_FZONE)
    e4:SetCountLimit(1,101054090)
	e4:SetCondition(c10105409.bdcon)
	e4:SetTarget(c10105409.bdtg)
	e4:SetOperation(c10105409.bdop)
	c:RegisterEffect(e4)
end
function c10105409.tg(e,c)
	return c:IsLevel(1) and  c:IsRace(RACE_ZOMBIE)
end

-- 场地魔法卡的②效果
function c10105409.ffilter(c)
    return c:IsLevel(1) and c:IsAbleToGrave()
end

function c10105409.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
    if chk==0 then 
        return Duel.IsExistingMatchingCard(c10105409.ffilter,tp,LOCATION_HAND,0,1,nil)
            and Duel.IsPlayerCanDraw(tp,1)
    end
    Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,0,tp,0)
    Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,0)
end

function c10105409.drop(e,tp,eg,ep,ev,re,r,rp)
    local g=Duel.GetMatchingGroup(c10105409.ffilter,tp,LOCATION_HAND,0,nil)
    if g:GetCount()==0 then return end
    
    Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
    local sg=g:Select(tp,1,g:GetCount(),nil)
    local ct=Duel.SendtoGrave(sg,REASON_EFFECT)
    
    if ct>0 and Duel.IsPlayerCanDraw(tp,ct) then
        Duel.BreakEffect()
        Duel.Draw(tp,ct,REASON_EFFECT)
    end
end

function c10105409.cfilter(c,tp)
	local rc=c:GetReasonCard()
	return c:IsReason(REASON_BATTLE) and c:IsPreviousControler(tp) and c:IsSetCard(0x7cc1)
		and rc and rc:IsControler(1-tp) and rc:IsRelateToBattle()
end
function c10105409.bdcon(e,tp,eg,ep,ev,re,r,rp)
	local dc=eg:Filter(c10105409.cfilter,nil,tp):GetFirst()
	if dc then
		e:SetLabelObject(dc:GetReasonCard())
		return true
	else return false end
end
function c10105409.bdtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetLabelObject(),1,0,0)
end
function c10105409.bdop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc and tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end