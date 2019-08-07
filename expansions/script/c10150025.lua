--棱镜原力
function c10150025.initial_effect(c)
	 --Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c10150025.target)
	e1:SetOperation(c10150025.activate)
	c:RegisterEffect(e1)	 
end

function c10150025.filter(c)
	return c:IsFaceup() and c:IsRace(RACE_WARRIOR)
end

function c10150025.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_MZONE) and c10150025.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c10150025.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c10150025.filter,tp,LOCATION_MZONE,0,1,1,nil)
end

function c10150025.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) or tc:IsFacedown() then return end
	local op=0
	local g=Duel.GetMatchingGroup(c10150025.tgfilter,tp,LOCATION_DECK,0,nil)
	 if g:GetCount()>0 then  
	   op=Duel.SelectOption(tp,aux.Stringid(10150025,0),aux.Stringid(10150025,1),aux.Stringid(10150025,2))
	 else
	   op=Duel.SelectOption(tp,aux.Stringid(10150025,0),aux.Stringid(10150025,1))
	 end
	  if op==0 then 
		Duel.Hint(HINT_SELECTMSG,tp,0)
		local att=Duel.AnnounceAttribute(tp,1,0x7f)
		 local e1=Effect.CreateEffect(c)
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_CHANGE_ATTRIBUTE)
		 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		 e1:SetValue(att)
		 e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		 tc:RegisterEffect(e1)
	  elseif op==1 then 
		local t={}
		local i=1
		local p=1
		local lv=e:GetHandler():GetLevel()
		for i=1,7 do 
		  if lv~=i then t[p]=i p=p+1 end
		end
		t[p]=nil
		 Duel.Hint(HINT_SELECTMSG,tp,aux.Stringid(10150025,4))
		 local lv=Duel.AnnounceNumber(tp,table.unpack(t))
		 local e1=Effect.CreateEffect(c)
		 e1:SetType(EFFECT_TYPE_SINGLE)
		 e1:SetCode(EFFECT_CHANGE_LEVEL)
		 e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		 e1:SetValue(lv)
		 e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		 tc:RegisterEffect(e1)
	  elseif op==2 then
		 Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
		 local tgc=g:Select(tp,1,1,nil):GetFirst()
		  if tgc and Duel.SendtoGrave(tgc,REASON_EFFECT)~=0 then
			local code1,code2=tgc:GetCode()
			local e1=Effect.CreateEffect(c)
			e1:SetDescription(aux.Stringid(10150025,3))
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_ADD_FUSION_CODE)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_CLIENT_HINT)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(code1)
			tc:RegisterEffect(e1)
			if code2 then
				local e2=e1:Clone()
				e2:SetValue(code2)
				tc:RegisterEffect(e2)
			end 
		  end
	  end
end

function c10150025.tgfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToGrave()
end


