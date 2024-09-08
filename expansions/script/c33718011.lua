--水物语-李伯
function c33718011.initial_effect(c)
--将你控制的1张「水之女演员 / Aquaactress」怪兽·「水族馆 / Aquarium」卡送去墓地；
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c33718011.cost)
	e1:SetTarget(c33718011.target)
	e1:SetOperation(c33718011.activate)
	c:RegisterEffect(e1)
--将此卡送去墓地，然后立刻跳到对手的下一个战斗阶段，

--在这个战斗阶段中，对手控制的怪兽只要可以就必须进行攻击。

end
function c33718011.filter(c)
	return c:IsSetCard(0xce) or c:IsSetCard(0xcd) and c:IsAbleToGraveAsCost()
end
function c33718011.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c33718011.filter,tp,LOCATION_ONFIELD,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c33718011.filter,tp,LOCATION_ONFIELD,0,1,1,nil)
	Duel.SendtoGrave(g,REASON_COST)
end
function c33718011.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
end
function c33718011.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsRelateToEffect(e) then
		if Duel.SendtoGrave(e:GetHandler(),nil,REASON_EFFECT)~=0 then
			local num=1
			while Duel.GetTurnPlayer()==1-tp and Duel.GetCurrentPhase()==PHASE_BATTLE_START do
				Duel.SkipPhase(Duel.GetTurnPlayer(),Duel.GetCurrentPhase(),RESET_PHASE+PHASE_END,1)
				num=num+1
				if num>10 then break end
			end
			local e2=Effect.CreateEffect(e:GetHandler())
			e2:SetType(EFFECT_TYPE_FIELD)
			e2:SetCode(EFFECT_MUST_ATTACK)
			e2:SetTargetRange(0,LOCATION_MZONE)
			e2:SetReset(RESET_PHASE+PHASE_END)
			Duel.RegisterEffect(e2,tp)
		end
	end
end
