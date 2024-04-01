GLITCHYLIB_ARCHETYPES_LOADED					= true

--ARCHETYPE : K.E.Y FRAGMENTS
if GLITCHYLIB_KEYFRAGMENT_LOADED then
	if not GLITCHYLIB_LOADED then
		Duel.LoadScript("glitchylib_vsnemo.lua")
	end
	if not STICKERS_LOADED then
		Duel.LoadScript("stickers.lua")
	end
	
	----Register the Sticker-placing K.E.Y. Fragment Quick Effect that activates from the hand by discarding the activator and paying LP
	function Auxiliary.RegisterKeyFragmentStickerQE(c,lpcost,sticker)
		local e1=Effect.CreateEffect(c)
		e1:Desc(11)
		e1:SetCustomCategory(CATEGORY_PLACE_STICKER)
		e1:SetType(EFFECT_TYPE_QUICK_O)
		e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
		e1:SetCode(EVENT_FREE_CHAIN)
		e1:SetRange(LOCATION_HAND)
		e1:SetRelevantTimings()
		e1:SetFunctions(aux.MainPhaseCond(),aux.KeyFragmentStickerQECost(lpcost),aux.KeyFragmentStickerQETarget(sticker),aux.KeyFragmentStickerQEOperation(sticker))
		c:RegisterEffect(e1)
		return e1
	end
	function Auxiliary.KeyFragmentStickerQEFilter(c,sticker,e,tp,REASON_EFFECT)
		return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_FIRE) and c:IsSetCard(ARCHE_KEY) and c:IsCanAddSticker(sticker,1,e,tp,REASON_EFFECT)
	end
	function Auxiliary.KeyFragmentStickerQECost(lpcost)
		return	function(e,tp,eg,ep,ev,re,r,rp,chk)
					local c=e:GetHandler()
					if chk==0 then
						return c:IsDiscardable() and Duel.CheckLPCost(tp,lpcost)
					end
					Duel.SendtoGrave(c,REASON_COST|REASON_DISCARD)
					Duel.PayLPCost(tp,lpcost)
				end
	end
	function Auxiliary.KeyFragmentStickerQETarget(sticker)
		return	function(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
						if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and aux.KeyFragmentStickerQEFilter(chkc,sticker,e,tp,REASON_EFFECT) end
						if chk==0 then
							return Duel.IsExists(true,aux.KeyFragmentStickerQEFilter,tp,LOCATION_MZONE,0,1,nil,sticker,e,tp,REASON_EFFECT)
						end
						local g=Duel.Select(HINTMSG_TARGET,true,tp,aux.KeyFragmentStickerQEFilter,tp,LOCATION_MZONE,0,1,1,nil,sticker,e,tp,REASON_EFFECT)
						Duel.SetCustomOperationInfo(0,CATEGORY_PLACE_STICKER,g,#g,0,0,sticker,1)
					end
	end
	function Auxiliary.KeyFragmentStickerQEOperation(sticker)
		return	function(e,tp,eg,ep,ev,re,r,rp)
						local tc=Duel.GetFirstTarget()
						if tc:IsRelateToChain() then
							tc:AddSticker(sticker,1,e,tp,REASON_EFFECT)
						end
					end
	end
	
	----Register the non-activated Sticker-placing K.E.Y. Fragment effects
	function Auxiliary.RegisterKeyFragmentStickerContinuous(c,id,sticker_self,sticker_oppo)
		local e1=Effect.CreateEffect(c)
		e1:SetCustomCategory(CATEGORY_PLACE_STICKER)
		e1:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_SUMMON_SUCCESS)
		e1:SetOperation(aux.KeyFragmentPlaceStickerOnItself(sticker_self))
		c:RegisterEffect(e1)
		local e2=e1:SpecialSummonEventClone(c)
		local reg=Effect.CreateEffect(c)
		reg:SetType(EFFECT_TYPE_SINGLE)
		reg:SetProperty(EFFECT_FLAG_CANNOT_DISABLE|EFFECT_FLAG_IGNORE_IMMUNE)
		reg:SetCode(33730147)
		reg:SetValue(sticker_self)
		c:RegisterEffect(reg)
		
		local e3=Effect.CreateEffect(c)
		e3:SetCustomCategory(CATEGORY_PLACE_STICKER)
		e3:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
		e3:SetCode(EVENT_BATTLE_DAMAGE)
		e3:SetCondition(aux.KeyFragmentOncePerBattle(id))
		e3:SetOperation(aux.KeyFragmentPlaceStickerOnOpponentCard(sticker_oppo,id,12))
		c:RegisterEffect(e3)
		local e4=Effect.CreateEffect(c)
		e4:SetCustomCategory(CATEGORY_PLACE_STICKER)
		e4:SetType(EFFECT_TYPE_SINGLE|EFFECT_TYPE_CONTINUOUS)
		e4:SetCode(EVENT_BATTLE_DESTROYING)
		e4:SetCondition(aux.AND(aux.bdocon,aux.KeyFragmentOncePerBattle(id)))
		e4:SetOperation(aux.KeyFragmentPlaceStickerOnOpponentCard(sticker_oppo,id,12))
		c:RegisterEffect(e4)
		return e1,e2,e3,e4
	end
	
	function Auxiliary.KeyFragmentPlaceStickerOnItself(sticker)
		return	function(e,tp,eg,ep,ev,re,r,rp)
					Duel.Hint(HINT_CARD,0,e:GetHandler():GetOriginalCode())
					local c=e:GetHandler()
					c:AddSticker(sticker,1,e,tp,REASON_EFFECT)
				end
	end
	function Auxiliary.KeyFragmentOncePerBattle(id)
		return	function(e,tp,eg,ep,ev,re,r,rp)
					return not e:GetHandler():HasFlagEffect(id)
				end
	end
	function Auxiliary.KeyFragmentPlaceStickerOnOpponentCard(sticker,id,desc)
		return	function(e,tp,eg,ep,ev,re,r,rp)
					if Duel.IsExists(false,Card.IsCanAddSticker,tp,0,LOCATION_ONFIELD,1,nil,sticker,1,e,tp,REASON_EFFECT) and Duel.SelectYesNo(tp,aux.Stringid(id,desc)) then
						local c=e:GetHandler()
						c:RegisterFlagEffect(id,RESET_EVENT|RESETS_STANDARD|RESET_PHASE|PHASE_DAMAGE_CAL,0,1)
						Duel.Hint(HINT_CARD,0,c:GetOriginalCode())
						local tc=Duel.Select(HINTMSG_OPERATECARD,false,tp,Card.IsCanAddSticker,tp,0,LOCATION_ONFIELD,1,1,nil,sticker,1,e,tp,REASON_EFFECT):GetFirst()
						if tc then
							Duel.HintSelection(Group.FromCards(tc))
							tc:AddSticker(sticker,1,e,tp,REASON_EFFECT)
						end
					end
				end
	end
end